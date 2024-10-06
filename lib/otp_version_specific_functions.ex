defmodule Misc.Random.OtpVersionSpecificFunctions do
  defmacro __using__(_opts \\ []) do
    otp_version =
      :otp_release |> :erlang.system_info() |> to_string() |> Integer.parse() |> elem(0)

    cond do
      otp_version <= 17 ->
        quote do
          def seed do
            :erlang.now() |> :random.seed()
          end

          def get_uniform(x), do: :random.uniform(x)
        end

  # use of erlang.now is deprecated in OTP 18
      otp_version == 18 ->
        quote do
          def seed do
            :erlang.monotonic_time() |> :random.seed()
          end

          def get_uniform(x), do: :random.uniform(x)
        end

      # random is deperecated for rand in OTP 19
      otp_version >= 19 ->
        quote do
          def seed do
            now = {
              :erlang.phash2([node()]),
              :erlang.monotonic_time(),
              :erlang.unique_integer()
            }

            :rand.seed(:exsplus, now)
          end

          def get_uniform(x), do: :rand.uniform(x)
        end
    end
  end
end
