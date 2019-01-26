defmodule PracticeWeb.PageControllerTest do
  use PracticeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "cs3650"
  end

  test "double 5", %{conn: conn} do
    conn = post conn, "/double", %{"x" => "5"}
    assert html_response(conn, 200) =~ "10"
  end

  test "calc 3 * 5 - 10 / 2", %{conn: conn} do
    conn = post conn, "/calc", %{"expr" => "3 * 5 - 10 / 2"}
    assert html_response(conn, 200) =~ "10"
  end

  test "factor 255", %{conn: conn} do
    conn = post conn, "/factor", %{"x" => "255"}
    assert html_response(conn, 200) =~ "17"
  end

  # TODO: Write a controller test for palindrome.
  test "palindrome abc", %{conn: conn} do
    conn = post conn, "/palindrome", %{"x" => "abc"}
    assert html_response(conn, 200) =~ "No"
  end

  test "palindrome abccba", %{conn: conn} do
    conn = post conn, "/palindrome", %{"x" => "abccba"}
    assert html_response(conn, 200) =~ "Yes"
  end


end
