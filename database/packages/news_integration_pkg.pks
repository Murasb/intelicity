create or replace package news_integration_pkg as

  subtype t_source_id is varchar2(255);
  subtype t_source_name is varchar2(255);
  subtype t_author is varchar2(255);
  subtype t_title is varchar2(255);
  subtype t_description is varchar2(255);
  subtype t_url is varchar2(255);
  subtype t_url_to_image is varchar2(255);
  subtype t_published_at is date;
  subtype t_content is clob;

  type t_article is record(
    source_id       t_source_id
  , source_name     t_source_name
  , author          t_author
  , title           t_title
  , description     t_description
  , url             t_url
  , url_to_image    t_url_to_image
  , published_at    t_published_at
  , content         t_content
  );
  
  type t_article_table is table of t_article;
  
  function get_articles(
      p_date_from date default sysdate
  ) return t_article_table pipelined;
  
  function make_request(
      p_date_string varchar2
  ) return clob;

end news_integration_pkg;