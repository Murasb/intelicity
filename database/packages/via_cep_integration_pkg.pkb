create or replace package body via_cep_integration as

  function get_address(
    p_cep varchar2
  ) return t_address_table pipelined 
  as

    cursor cr_response_ws ( p_response clob ) is
        select json_value( p_response, '$.cep' )            as cep
             , json_value( p_response, '$.logradouro' )     as logradouro
             , json_value( p_response, '$.complemento' )    as complemento
             , json_value( p_response, '$.bairro' )         as bairro
             , json_value( p_response, '$.localidade' )     as localidade
             , json_value( p_response, '$.uf' )             as uf
             , json_value( p_response, '$.ibge' )           as ibge
             , json_value( p_response, '$.gia' )            as gia
             , json_value( p_response, '$.ddd' )            as ddd
             , json_value( p_response, '$.siafi' )          as siafi
        from dual;

    l_response clob;
  begin 

    make_request(
         p_cep => p_cep
       , p_out_response => l_response 
       );

    for r in cr_response_ws( l_response ) loop
    
      pipe row( t_address( 
            cep         => r.cep
          , logradouro  => r.logradouro
          , complemento => r.complemento
          , bairro      => r.bairro
          , localidade  => r.localidade
          , uf          => r.uf
          , ibge        => r.ibge
          , gia         => r.gia
          , ddd         => r.ddd
          , siafi       => r.siafi 
          ) 
      );
    end loop;

    return;
  exception
    when no_data_needed then
      return;
    when no_data_found then
      return;
    when others then
      raise_application_error( -20001, 'Error to get address: ' || sqlerrm );
  end get_address;

  procedure make_request(
    p_cep varchar2
  , p_out_response out clob
  ) as
  begin
  
    p_out_response := APEX_WEB_SERVICE.MAKE_REST_REQUEST(
      p_url => 'https://viacep.com.br/ws/'||p_cep||'/json/',
      p_http_method => 'GET'
   );

  exception
    when others then
      raise_application_error( -20002, 'Error to make request: ' || sqlerrm );
  end make_request;

end via_cep_integration;