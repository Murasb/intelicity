create or replace package intelicity_authentication_pkg as

  subtype t_username is varchar2(255);
  subtype t_password is varchar2(255);

  function authenticate_user(
    p_username t_username
  , p_password t_password
  ) return boolean;

  procedure create_user(
    p_username t_username
  , p_password t_password
  , p_out_user_id out number
  );

  procedure delete_user(
    p_username t_username
  );

  procedure update_password(
    p_username     t_username
  , p_old_password t_password
  , p_new_password t_password
  );

  function get_hash ( 
    p_username t_username
  , p_password t_password 
  ) return varchar2;

end intelicity_authentication_pkg;