defmodule HttpRequest do
  defstruct [
    request_line: nil,
    headers: [],
    body: nil
  ]

  @spec parse(binary) :: %HttpRequest{
          body: any,
          headers: list,
          request_line: %HttpRequestLine{location: binary, method: binary, version: binary}
        }
  def parse(request) do
    split_request = String.split(request, ~r{(\r\n|\r|\n)})
    {request_line, rest} = Enum.split(split_request, 1)

    request_line = HttpRequestLine.parse(Enum.at(request_line, 0))

    {headers, body} = Enum.split_while(rest, fn x -> x != "" end)

    headers = Enum.map(headers, fn x -> HttpHeader.parse(x) end)

    body = List.foldl(body, "", fn (x, acc) -> acc <> x end)

    %HttpRequest{request_line: request_line, headers: headers, body: body}
  end

  defimpl Inspect, for: HttpRequest do
    @spec inspect(%HttpRequest{}, any) :: <<_::64, _::_*8>>
    def inspect(%HttpRequest{ request_line: request_line, headers: headers, body: body}, _opts) do
      """

        REQUEST LINE: #{request_line}
        --
        HEADERS: #{inspect(headers)}
        --
        BODY: #{inspect(body)}
      """
    end
  end
end
