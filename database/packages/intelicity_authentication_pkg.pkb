create or replace package body intelicity_authentication_pkg as

  function authenticate_user(
    p_username t_username
  , p_password t_password
  ) return boolean
  is
    l_user_id number;
    l_password varchar2(4000);
  begin
  
    select id, password
    into l_user_id, l_password
    from intelicity_users
    where trim(upper(username)) = trim(upper(p_username));

    update intelicity_users
       set last_login = sysdate
     where id = l_user_id;

    return l_password = get_hash( p_username => p_username
                                , p_password => p_password  );
  exception
    when no_data_found then
      return false;
  end authenticate_user;

  procedure create_user(
    p_username    t_username
  , p_password    t_password
  , p_out_user_id out number
  )
  is
    pragma autonomous_transaction;
  begin

    insert into intelicity_users( username , password)
    values (p_username, p_password)
    returning id into p_out_user_id;

    commit;

  exception
    when others then
      dbms_output.put_line( 'Error to create user: ' || sqlerrm );
  end create_user;

  procedure delete_user(
    p_username t_username
  )
  is
    l_user_id_removed number;
    pragma autonomous_transaction;
  begin

   insert into intelicity_users_history(
     id 
   , name 
   , username 
   , password 
   , created_at 
   , created_by 
   , updated_at 
   , updated_by
    ) select id 
        , name 
        , username 
        , password 
        , created_at 
        , created_by 
        , updated_at 
        , updated_by
     from intelicity_users
    where username = p_username;
    
    delete from intelicity_users
     where username = p_username;
     
    commit;
  exception
    when others then
      dbms_output.put_line( 'Error to delete user: ' || sqlerrm );
  end delete_user;

  procedure update_password(
    p_username     t_username
  , p_old_password t_password
  , p_new_password t_password
  )
  is
    l_new_password t_password;
    l_old_password t_password;
  begin
    
    l_new_password := get_hash( 
        p_username => p_username
      , p_password => p_new_password 
    );

    l_old_password := get_hash( 
        p_username => p_username
      , p_password => p_old_password 
    );

    update intelicity_users
       set password = l_new_password
     where name = p_username
       and password = l_old_password;

  end update_password;

  function get_hash ( 
    p_username t_username
  , p_password t_password 
  ) return varchar2 as
  
    l_password varchar2(255);
    
  begin  

      l_password := rawtohex(sys.dbms_crypto.hash ( sys.utl_raw.cast_to_raw ( p_username || p_password ), sys.dbms_crypto.hash_sh512 ));
    
    return l_password;
    
  exception 
    when others then
      dbms_output.put_line( 'Error to get hash: ' || sqlerrm );
      return null;
  end get_hash;

end intelicity_authentication_pkg;