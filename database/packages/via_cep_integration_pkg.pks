create or replace package via_cep_integration as

  type t_address is record(
    cep varchar2(100)
  , logradouro varchar2(255)
  , complemento varchar2(255)
  , bairro varchar2(255)
  , localidade varchar2(255)
  , uf varchar2(100)
  , ibge varchar2(255)
  , gia varchar2(255)
  , ddd varchar2(255)
  , siafi varchar2(255)
  );

  type t_address_table is table of t_address;

  function get_address(
    p_cep varchar2
  ) return t_address_table pipelined;

  procedure make_request(
    p_cep varchar2
  , p_out_response out clob
  );

end via_cep_integration;