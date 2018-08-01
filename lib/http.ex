defmodule Dgraph.Http do
  @moduledoc """
  HTTP interface for Dgraph
  """

{ loc(func: uid(0x102ca7) { uid Name PhoneNumber { uid Number } PodiumNumber { uid Number } } }

  use HTTPoison.Base

  def process_url(url) do
    Application.get_env(:ex_dgraph, :dgraph_url) <> url
  end

  def process_response_body("") do
    ""
  end

  def process_response_body(body) do
    body
    |> Poison.decode!()
  end

  @doc """
  This is the endpoint that you use to modify schema and other things
  """
  def alter(query) do
    case Dgraph.Http.post("/alter", query) do
      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body: %{"data" => %{"code" => "Success", "message" => message}}
       }} ->
        {:ok, message}

      {:ok,
       %HTTPoison.Response{
         body: %{
           "errors" => [%{"code" => "Error", "message" => message}]
         }
       }} ->
        {:error, message}

      {:ok,
       %HTTPoison.Response{
         status_code: code,
         body: body
       }}
      when code > 200 ->
        {:error, "Invalid status code #{code}, body: #{inspect(body)}"}

      e ->
        {:error, "unknown error occurred, #{inspect(e)}"}
    end
  end

  @doc """
  this will *delete all the data in the database* use caution!
  """
  def drop_all(:i_know_what_im_doing) do
    alter(~s({"drop_all": true}))
  end

  @doc """
  this will *delete all the data in the database* use caution!
  """
  def drop_predicate(predicate) when is_string(predicate) do
    alter(~s({{"drop_attr": "#{predicate}"}}))
  end

  def query(query, lin_read_map) do
    case Dgraph.Http.post("/query", query, [{:"X-Dgraph-LinRead", Poison.encode!(lin_read_map)}]) do
      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body: %{
           "errors" => errors
         }
       }} ->
        {:error, errors}

      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body: body
       }} ->
        {:ok, body}

      {:ok,
       %HTTPoison.Response{
         status_code: code,
         body: body
       }}
      when code > 200 ->
        {:error, "Invalid status code #{code}, body: #{inspect(body)}"}

      e ->
        {:error, "unknown error occurred, #{inspect(e)}"}
    end
  end
end
