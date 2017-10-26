package academy.softserve.sso.repository;//package academy.softserve.aura.core.repository;


import academy.softserve.sso.entity.User;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends CrudRepository<User, Long> {

    User findByLogin(String login);

}
