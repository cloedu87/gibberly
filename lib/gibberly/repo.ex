defmodule Gibberly.Repo do
  use AshPostgres.Repo,
    otp_app: :gibberly

  def installed_extensions do
    # Add extensions here, and the migration generator will install them.
    ["ash-functions"]
  end

  # Don't open unnecessary transactions
  # will default to `false` in 4.0
  def prefer_transaction? do
    false
  end

  def min_pg_version do
    %Version{major: 17, minor: 4, patch: 0}
  end
end
