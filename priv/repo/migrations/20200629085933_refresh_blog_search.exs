defmodule MyHive.Repo.Migrations.RefreshBlogSearch do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE OR REPLACE FUNCTION refresh_blog_search()
      RETURNS TRIGGER LANGUAGE plpgsql
      AS $$
      BEGIN
      REFRESH MATERIALIZED VIEW CONCURRENTLY blog_search;
      RETURN NULL;
      END $$;
      """
    )

    execute(
      """
      CREATE TRIGGER refresh_blog_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON blog_posts
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_blog_search();
      """
    )

    execute(
      """
      CREATE TRIGGER refresh_blog_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON blog_tags
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_blog_search();
      """
    )

  end
end
