defmodule AbsintheConstraints.Validator do
  @moduledoc """
  Defines all the constraint handlers for the `constraints` directive.
  """

  def handle_constraint({:min, min}, _value, %{input_value: %{data: decimal = %Decimal{}}}) do
    if is_integer(min) and Decimal.lt?(decimal, min),
      do: ["must be less than or equal to #{min}"],
      else: []
  end

  def handle_constraint({:min, min}, value, _node) do
    if value < min,
      do: ["must be greater than or equal to #{min}"],
      else: []
  end

  def handle_constraint({:max, max}, _value, %{input_value: %{data: decimal = %Decimal{}}}) do
    if is_integer(max) and Decimal.gt?(decimal, max),
      do: ["must be less than or equal to #{max}"],
      else: []
  end

  def handle_constraint({:max, max}, value, _node) do
    if value > max,
      do: ["must be less than or equal to #{max}"],
      else: []
  end

  def handle_constraint({:min_items, min_items}, value, _node) do
    if length(value) < min_items,
      do: ["must have at least #{min_items} items"],
      else: []
  end

  def handle_constraint({:min_length, min_length}, value, _node) do
    if String.length(value) < min_length,
      do: ["must be at least #{min_length} characters in length"],
      else: []
  end

  def handle_constraint({:max_items, max_items}, value, _node) do
    if length(value) > max_items,
      do: ["must have no more than #{max_items} items"],
      else: []
  end

  def handle_constraint({:max_length, max_length}, value, _node) do
    if String.length(value) > max_length,
      do: ["must be no more than #{max_length} characters in length"],
      else: []
  end

  def handle_constraint({:format, "uuid"}, value, _node) do
    case UUID.info(value) do
      {:ok, _} -> []
      {:error, _} -> ["must be a valid UUID"]
    end
  end

  @email_regex ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/

  def handle_constraint({:format, "email"}, value, _node) do
    if String.match?(value, @email_regex),
      do: [],
      else: ["must be a valid email address"]
  end

  def handle_constraint({:pattern, regex}, value, _node) do
    if String.match?(value, Regex.compile!(regex)),
      do: [],
      else: ["must match regular expression `#{regex}`"]
  end
end
