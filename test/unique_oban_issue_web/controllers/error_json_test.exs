defmodule UniqueObanIssueWeb.ErrorJSONTest do
  use UniqueObanIssueWeb.ConnCase, async: true

  test "renders 404" do
    assert UniqueObanIssueWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert UniqueObanIssueWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
