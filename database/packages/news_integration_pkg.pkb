create or replace package body news_integration_pkg as

  function get_articles(
    p_date_from date default sysdate
  ) return t_article_table pipelined
  as
   cursor cr_response_ws ( p_response clob ) is
    select jt.source_id
         , jt.source_name
         , jt.author
         , jt.title
         , jt.description
         , jt.url
         , jt.url_to_image
         , jt.published_at
         , jt.content
      from json_table(
               p_response,
               '$.articles[*]'
               columns (
                   source_id      varchar2(255) path '$.source.id'
                 , source_name    varchar2(255) path '$.source.name'
                 , author         varchar2(255) path '$.author'
                 , title          varchar2(255) path '$.title'
                 , description    varchar2(255) path '$.description'
                 , url            varchar2(255) path '$.url'
                 , url_to_image   varchar2(255) path '$.urlToImage'
                 , published_at   varchar2(255) path '$.publishedAt'
                 , content        clob          path '$.content'
               )
           ) jt;


    l_response clob;
    l_json json;
    l_article_record t_article;
  begin 

    select to_clob( news_integration_pkg.make_request(
        p_date_string => to_char(p_date_from, 'YYYY-MM-DD')
      ) ) into l_response 
      from dual;
    
    for r in cr_response_ws( l_response ) loop
      l_article_record.source_name := r.source_name;
      l_article_record.author := r.author;
      l_article_record.title := r.title;
      l_article_record.description := r.description;
      l_article_record.url := r.url;
      l_article_record.url_to_image := r.url_to_image;
      l_article_record.published_at := to_date(r.published_at, 'YYYY-MM-DD"T"HH24:MI:SS"Z"');
      l_article_record.content := r.content;

      pipe row( l_article_record );
    end loop;

  exception
    when no_data_needed then
      return;
    when no_data_found then
      return;
    when others then
      raise_application_error( -20001, 'Error to get articles: ' || sqlerrm );
  end get_articles;

  function make_request(
      p_date_string  varchar2 
  ) return clob
  is
    l_endpoint      varchar2(4000) := 'https://newsapi.org/v2/everything?q=tesla&from=' || p_date_string || '&sortBy=publishedAt&apiKey=';
    l_api_key       varchar2(255) := '#KEY#';
    l_request_url   varchar2(4000); 
    l_response      clob;
  begin
    -- Construindo a URL com a data dinâmica
    l_request_url := l_endpoint || l_api_key;
    
    -- Adicionando cabeçalho User-Agent exigido pela API
    apex_web_service.set_request_headers(
      p_name_01        => 'Content-Type'
    , p_value_01       => 'application/json'
    , p_name_02        => 'User-Agent'
    , p_value_02       => 'OraclAPEX Intelicity'
    );
    
    -- Log para depuração (opcional)
    dbms_output.put_line('Request URL: ' || l_request_url);
    
    -- Fazendo a requisição com o cabeçalho necessário
    l_response := apex_web_service.make_rest_request(
        p_url         => l_request_url,
        p_http_method => 'GET'
    ); 
    
    return l_response;
   
  exception
    when others then
      raise_application_error(-20001, 'Error to make request: ' || sqlerrm);
  end make_request;

end news_integration_pkg;