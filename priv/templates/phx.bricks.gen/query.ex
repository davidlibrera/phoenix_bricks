defmodule <%= inspect schema.module %>Query do
  @moduledoc false

  import Ecto.Query, warn: false

  def starting_scope do
    <%= inspect schema.module %>
  end

  def scope(scopes, starting_scope) do
    scopes
    |> Enum.reduce(starting_scope, fn scope, query ->
      apply_scope(query, scope)
    end)
  end

  def scope(scopes) do
    scope(scopes, starting_scope())
  end

  def scope do
    starting_scope()
  end

  def apply_scope(query, {column, {:eq, value}}) do
    where(query, [q], field(q, ^column) == ^value)
  end

  def apply_scope(query, {column, {:neq, value}}) do
    where(query, [q], field(q, ^column) != ^value)
  end

  def apply_scope(query, {column, {:lte, value}}) do
    where(query, [q], field(q, ^column) <= ^value)
  end

  def apply_scope(query, {column, {:lt, value}}) do
    where(query, [q], field(q, ^column) < ^value)
  end

  def apply_scope(query, {column, {:gte, value}}) do
    where(query, [q], field(q, ^column) >= ^value)
  end

  def apply_scope(query, {column, {:gt, value}}) do
    where(query, [q], field(q, ^column) > ^value)
  end

  def apply_scope(query, {column, {:matches, value}}) do
    value = "%#{value}%"
    where(query, [q], ilike(field(q, ^column), ^value))
  end
<%= for {name, matcher, _} <- schema.fields do %>
  def apply_scope(query, {:<%= "#{name}_#{matcher}" %>, value}) do
    apply_scope(query, {:<%= name %>, {:<%= matcher %>, value}})
  end
<% end %>end
