defmodule ImageUploaderWeb.UploadController do
  use ImageUploaderWeb, :controller
  alias ImageUploader.Producer

  def image_upload(conn, %{"device_id" => id, "image" => image}) do
    Producer.add({id, image})

    conn
    |> send_resp(:created, "")
  end
end
