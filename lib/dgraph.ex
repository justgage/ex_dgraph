defmodule Dgraph do
  @moduledoc """
  This is the main way you interact with Dgraph
  """

  @moduledoc """
  TODO wrote docs for Dgraph.Http
  """

  defmodule Client do
    @moduledoc """
    TODO wrote docs for Client
    """
    defstruct [
      url: '',
      lin_read: %{},
    ]
  end

  defmodule Transaction do

    defstruct [
      client: %Client{},
      start_ts: 0 # TODO: is this a good default?
    ]
  end

  def create_client(url) do

  end

  # curl -X POST localhost:8080/alter -d 'name: string @index(term) .'
  def alter(client, query) do

  end

  # the new map gets all key/value pairs from the parent
  # maps. Where a key exists in both maps, the max value
  # is taken. The client’s initial lin_read is should be
  # an empty map.
  defp merge_lin_read(client = %{lin_read: lin_read}) do
  end

end
