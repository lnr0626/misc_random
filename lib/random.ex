defmodule Misc.Random do
  use Misc.Random.OtpVersionSpecificFunctions

  def seed_random do
    seed()
  end

  @doc """
  Generates a random string that will always start with a character.
  """
  def string(length \\ 8) do
    seed_random()
    get_string(length)
  end

  defp get_string(1) do
    default_alphabet(:alpha) |> get_random_char
  end

  defp get_string(length) when length > 1 do
    first = get_string(1)
    rest = Enum.map_join(2..length, fn _ -> default_alphabet() |> get_random_char() end)
    first <> rest
  end

  def get_random_char(alphabet) do
    alphabet_length = alphabet |> String.length()
    get_random_char(alphabet, alphabet_length)
  end

  def get_random_char(alphabet, alphabet_length) do
    alphabet |> String.at(uniform(alphabet_length) - 1)
  end

  @doc """
  Generates a random number as string that will not start with leading zeroes.
  """
  def number(length \\ 8) do
    seed_random()

    length
    |> get_number()
    |> Integer.parse()
    |> elem(0)
  end

  defp get_number(1) do
    default_alphabet(:numeric_wo_zeroes) |> get_random_char()
  end

  defp get_number(length) when is_integer(length) do
    first = get_number(1)
    rest = Enum.map_join(2..length, fn _ -> default_alphabet(:numeric) |> get_random_char end)
    first <> rest
  end

  def default_alphabet do
    default_alphabet(:alpha) <> default_alphabet(:numeric)
  end

  def default_alphabet(:alpha) do
    "abcdefghijklmnopqrstuvwxyz" <> "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  end

  def default_alphabet(:numeric) do
    default_alphabet(:numeric_wo_zeroes) <> "0"
  end

  def default_alphabet(:numeric_wo_zeroes) do
    "123456789"
  end

  def uniform(x), do: get_uniform(x)
end
