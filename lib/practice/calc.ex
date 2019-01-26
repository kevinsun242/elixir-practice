defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> to_postfix
    |> to_prefix
    |> evaluate
  end

  def tag_tokens(expr) do
    Enum.map(expr, fn x -> 
      cond do 
        x == "+" || x == "-" || x == "*" || x == "/" ->
          {:op, x}
        true ->
          {:num, String.to_integer(x)}
      end
      end)
  end
 
  def to_postfix(expr) do
    to_postfix_helper(expr, [], [])
  end

  def to_postfix_helper(expr, postfix, operators) do
    cond do
      length(expr) == 0 && length(operators) == 0 ->
        postfix
      length(expr) == 0 && length(operators) > 0 ->
        pop_operator(expr, postfix, operators)
      true ->
        process_expr(hd(expr), expr, postfix, operators)
    end
  end

  def process_expr({:num, x}, expr, postfix, operators) do
    to_postfix_helper(tl(expr), postfix ++ [{:num, x}], operators)
  end

  def process_expr({:op, _}, expr, postfix, operators) do
    to_stack_operator(expr, postfix, operators)  
  end

  def to_stack_operator(expr, postfix, operators) do
    cond do
      length(operators) == 0 ->
        to_postfix_helper(tl(expr), postfix, operators ++ [hd(expr)])
      hd(expr) == {:op, "+"} || hd(expr) == {:op, "-"} ->
        pop_operator(expr, postfix, operators)
      hd(expr) == {:op, "*"} && Enum.take(operators, -1) == {:op, "*"} ->
        pop_operator(expr, postfix, operators)
      hd(expr) == {:op, "*"} && Enum.take(operators, -1) == {:op, "/"} ->
        pop_operator(expr, postfix, operators)
      hd(expr) == {:op, "/"} && Enum.take(operators, -1) == {:op, "*"} ->
        pop_operator(expr, postfix, operators)
      hd(expr) == {:op, "/"} && Enum.take(operators, -1) == {:op, "/"} ->
        pop_operator(expr, postfix, operators)
      true ->
        to_postfix_helper(tl(expr), postfix, operators ++ [hd(expr)])
    end
  end

  def pop_operator(expr, postfix, operators) do 
    to_postfix_helper(expr, 
                      postfix ++ [Enum.at(Enum.take((operators), -1), 0)], 
                      Enum.drop(operators, -1))
  end

  # Convert to prefix notation 
  # Since there are no parens, you can simply reverse postfix
  def to_prefix(expr) do
    Enum.reverse(expr)
  end

  def evaluate(expr) do 
    cond do
      length(expr) == 1 ->
        elem(Enum.at(expr, 0), 1)
      true ->
        evaluate_helper(Enum.at(expr, -1), expr, [])
    end
  end
  
  def evaluate_helper(x, _, stack) when x == nil do 
    Enum.at(stack, 0)
  end

  def evaluate_helper({:num, x}, expr, stack) do
    evaluate_helper(Enum.at(expr, -2), Enum.drop(expr, -1), stack ++ [x])
  end 

  def evaluate_helper({:op, operator}, expr, stack) do
    cond do
      length(stack) == 1 ->
        Enum.at(stack, 0)
      operator == "+" ->
        evaluate_helper(Enum.at(expr, -2), 
                        Enum.drop(expr, -1),
                        Enum.drop(stack, -2) ++ [Enum.at(stack, -2) + Enum.at(stack, -1)])
      operator == "-" ->
        evaluate_helper(Enum.at(expr, -2),
                        Enum.drop(expr, -1),
                        Enum.drop(stack, -2) ++ [Enum.at(stack, -2) - Enum.at(stack, -1)])
      operator == "*" ->
        evaluate_helper(Enum.at(expr, -2),
                        Enum.drop(expr, -1),
                        Enum.drop(stack, -2) ++ [Enum.at(stack, -2) * Enum.at(stack, -1)])
      operator == "/" ->
        evaluate_helper(Enum.at(expr, -2),
                        Enum.drop(expr, -1),
                        Enum.drop(stack, -2) ++ [Enum.at(stack, -2) / Enum.at(stack, -1)])
                        
    end
  end
end
