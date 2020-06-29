defmodule MyHive.Repo.Migrations.AddBlogSearch do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE EXTENSION pg_trgm;
      """
    )
    execute(
      """
      CREATE EXTENSION IF NOT EXISTS unaccent
      """
    )
    execute(
      """
      CREATE MATERIALIZED VIEW blog_search AS
      SELECT
        blog_posts.id AS id,
        blog_posts.title AS title,
        (
        setweight(to_tsvector(unaccent(blog_posts.title)), 'A') ||
        setweight(to_tsvector(unaccent(coalesce(string_agg(blog_tags.name, ' '), ' '))), 'B')
        ) AS document
      FROM blog_posts
      LEFT JOIN blog_posts_tags ON blog_posts_tags.post_id = blog_posts.id
      LEFT JOIN blog_tags ON blog_tags.id = blog_posts_tags.tag_id
      GROUP BY blog_posts.id
      """
    )
    # to support full-text searches
    create index("blog_search", ["document"], using: :gin)

    # to support substring title matches with ILIKE
    execute("CREATE INDEX blog_search_title_trgm_index ON blog_search USING gin (title gin_trgm_ops)")

    # to support updating CONCURRENTLY
    create unique_index("blog_search", [:id])
  end
end
