create or replace trigger trg_biu_intelicity_users
before insert or update on intelicity_users
for each row
begin
    if inserting then
        :new.id := seq_intelicity_users.nextval;
        :new.created_at := current_timestamp;
        :new.created_by := user;
    end if;
    :new.updated_at := current_timestamp;
    :new.updated_by := user;
    :new.username := upper(:new.username);
    :new.password := intelicity_authentication_pkg.get_hash(
        p_username => :new.username
      , p_password => :new.password
    );
end;
