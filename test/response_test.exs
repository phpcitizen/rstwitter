defmodule RsTwitterTest.Response do
  use ExUnit.Case, async: true
  doctest RsTwitter.Response

  test "fetch rate_limit_remaining" do
    response = %RsTwitter.Response{body: nil, status_code: 200, headers: headers()}
    assert 897 == RsTwitter.Response.rate_limit_remaining(response)
  end

  test "fetch rate_limit_remaining returns nil" do
    response = %RsTwitter.Response{body: nil, status_code: 200, headers: []}
    refute RsTwitter.Response.rate_limit_remaining(response)
  end

  test "fetch rate_limit_reset" do
    response = %RsTwitter.Response{body: nil, status_code: 200, headers: headers()}
    assert 1_534_246_050 == DateTime.to_unix(RsTwitter.Response.rate_limit_reset(response))
  end

  test "fetch rate_limit_reset returns nil" do
    response = %RsTwitter.Response{body: nil, status_code: 200, headers: []}
    refute RsTwitter.Response.rate_limit_reset(response)
  end

  defp headers() do
    [
      {"x-frame-options", "SAMEORIGIN"},
      {"x-rate-limit-limit", "900"},
      {"x-rate-limit-remaining", "897"},
      {"x-rate-limit-reset", "1534246050"}
    ]
  end

  test "if response is successfull" do
    response = %RsTwitter.Response{status_code: 200, body: nil, headers: []}
    assert RsTwitter.Response.success?(response)
    response = %RsTwitter.Response{status_code: 400, body: nil, headers: []}
    refute RsTwitter.Response.success?(response)
  end

  test "error code matches" do
    body = %{
      "errors" => [
        %{"message" => "Sorry, that page does not exist", "code" => 34},
        %{"message" => "You are unable to follow more people at this time", "code" => 161}
      ]
    }

    response = %RsTwitter.Response{status_code: 400, body: body, headers: []}
    assert RsTwitter.Response.has_error_code?(response, 161)
  end
end
