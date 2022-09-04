defmodule HttpRequestLine do
  defstruct [
    method: nil,
    location: nil,
    version: nil
  ]

  @spec parse(binary) :: %HttpRequestLine{location: binary, method: binary, version: binary}
  def parse(request_line) when is_binary(request_line) do
    [method, location, version] = String.split(request_line, " ", [parts: 3, trim: :true])
    %HttpRequestLine{method: method, location: location, version: version}
  end

  defimpl String.Chars, for: HttpRequestLine do
    @spec to_string(%HttpRequestLine{}) :: <<_::16, _::_*8>>
    def to_string(%HttpRequestLine{method: method, location: location, version: version}) do
      "#{method} #{location} #{version}"
    end
  end

  defimpl Inspect, for: HttpRequestLine do
    @spec inspect(%HttpRequestLine{}, any) :: binary
    def inspect(%HttpRequestLine{method: method, location: location, version: version}, _opt) do
      """
        METHOD: #{method}, Location: #{location}, HTTP Version: #{version}
      """
    end
  end
end
