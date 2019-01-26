defmodule PracticeWeb.PageController do
  use PracticeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def double(conn, %{"x" => x}) do
    {x, _} = Integer.parse(x)
    y = Practice.double(x)
    render conn, "double.html", x: x, y: y
  end

  def calc(conn, %{"expr" => expr}) do
    y = Practice.calc(expr)
    render conn, "calc.html", expr: expr, y: y
  end

  def factor(conn, %{"x" => x}) do
    {x, _} = Integer.parse(x)
    y = Practice.factor(x)
    ystr = Enum.join(y, " ")
    render conn, "factor.html", x: x, y: ystr
  end

  def palindrome(conn, %{"x" => x}) do
    cond do
      Practice.palindrome?(x) ->
        y = "Yes"
        render conn, "palindrome.html", x: x, y: y
      true -> 
        y = "No"
        render conn, "palindrome.html", x: x, y: y
    end
  end
end
