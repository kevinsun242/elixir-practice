defmodule Practice.Factor do

  def factor(x) do
    factor_helper(x, 2, []) 
  end

  def factor_helper(x, factor, factors) do 
    cond do 
      (x < factor) ->
        factors
      (rem(x, factor) == 0) ->
        [factor | factor_helper(div(x, factor), factor, factors)]
      true ->
        factor_helper(x, (factor + 1), factors)
    end
  end
    
    
end
