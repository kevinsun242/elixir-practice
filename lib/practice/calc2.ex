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

  def process_expr({:op, x}, expr, postfix, operators) do
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
    to_postfix_helper(expr, postfix ++ [Enum.take((operators), -1)], Enum.drop(operators, -1))
  end

  
    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching

end
