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

  # tag_tokens: turns each character into a tuple with either 
  # {:num} or {:op} identifying it as a number of operator
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
 
  # to_postfix: convert the string into postfix notation
  def to_postfix(expr) do
    to_postfix_helper(expr, [], [])
  end

  # to_postfix_helper: 
  # expr is the current expression
  # postfix is the postfix expression 
  # operators is the stack of operators to be appended to postfix
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

  # process_expr: If the next character is a number, append it to
  # the postfix expression
  def process_expr({:num, x}, expr, postfix, operators) do
    to_postfix_helper(tl(expr), postfix ++ [{:num, x}], operators)
  end

  # process_expr: If the next character is an operator, push it
  # to the stack of operators
  def process_expr({:op, _}, expr, postfix, operators) do
    to_stack_operator(expr, postfix, operators)  
  end

  # to_stack_operator: Push the operator to the stack of operators.
  # operators cannot be in front of another operator of the same 
  # or higher priority, so those need to be popped from the stack and
  # appended to the postfix expression before the current operator can
  # be pushed.
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

  # pop_operator: pop an operator from the stack and append to postfix
  # the last operator pushed to stack is popped first
  def pop_operator(expr, postfix, operators) do 
    to_postfix_helper(expr, 
                      postfix ++ [Enum.at(Enum.take((operators), -1), 0)], 
                      Enum.drop(operators, -1))
  end

  # to_prefix: Convert to prefix notation 
  # Since there are no parens, you can simply reverse postfix
  def to_prefix(expr) do
    Enum.reverse(expr)
  end

  # evaluate: evaluate the prefix expression
  # if the length of the expression is 1, then it is just a number
  # so return that number
  # Prefix is evaluated by scanning the expressing backwards
  def evaluate(expr) do 
    cond do
      length(expr) == 1 ->
        elem(Enum.at(expr, 0), 1)
      true ->
        evaluate_helper(Enum.at(expr, -1), expr, [])
    end
  end
  
  # evaluate_helper: if the expression is empty, then no more operations
  # are needed so return the value
  def evaluate_helper(x, _, stack) when x == nil do 
    Enum.at(stack, 0)
  end

  # evaluate_helper: if the next character is a nunmber, push it to the
  # stack
  def evaluate_helper({:num, x}, expr, stack) do
    evaluate_helper(Enum.at(expr, -2), Enum.drop(expr, -1), stack ++ [x])
  end 
  
  # evaluate_helper: if the next character is an operator, pop the last two
  # numbers pushed to the stack, evaluate them (with the last pushed number)
  # on the right hand side, then push the new value to the stack
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
