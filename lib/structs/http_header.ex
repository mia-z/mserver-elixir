defmodule HttpHeader do
  defstruct [
    key: nil,
    value: nil
  ]

  def as_string(%HttpHeader{key: key, value: value}) do
    "#{key}: #{value}"
  end

  @spec parse(binary) :: %HttpHeader{key: binary, value: binary}
  def parse(header) when is_binary(header) do
    [key, value] = String.split(header, ":", [parts: 2, trim: :true])
    %HttpHeader{ key: key, value: value}
  end

  defimpl String.Chars, for: HttpHeader do
    @spec to_string(%HttpHeader{}) :: <<_::16, _::_*8>>
    def to_string(%HttpHeader{key: key, value: value}) do
      "#{key}: #{value}"
    end
  end

  defimpl Inspect, for: HttpHeader do
    @spec inspect(%HttpHeader{}, any) :: <<_::64, _::_*8>>
    def inspect(%HttpHeader{key: key, value: value}, _opt) do
      """
        Header Key: #{key}, Header Value: #{value}
      """
    end
  end
end
