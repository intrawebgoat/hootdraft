<?php

namespace PhpDraft\Domain\Repositories;

use Silex\Application;
use PhpDraft\Domain\Entities\LoginUser;
use Symfony\Component\Security\Core\Exception\UsernameNotFoundException;

class LoginUserRepository {
  private $app;

  public function __construct(Application $app) {
    $this->app = $app;
  }

  public function Load($email) {
    $user = new LoginUser();

    $load_stmt = $this->app['db']->prepare("SELECT * FROM users WHERE email = ? LIMIT 1");
    $load_stmt->setFetchMode(\PDO::FETCH_INTO, $user);
    $load_stmt->bindParam(1, strtolower($email));

    if (!$load_stmt->execute())
      throw new \Exception(sprintf('Email "%s" does not exist.', $email));

    if (!$load_stmt->fetch())
      throw new \Exception(sprintf('Email "%s" does not exist.', $email));

    return $user;
  }

  public function LoadById($id) {
    $user = new LoginUser();

    $id = (int)$id;

    $load_stmt = $this->app['db']->prepare("SELECT * FROM users WHERE id = ? LIMIT 1");
    $load_stmt->setFetchMode(\PDO::FETCH_INTO, $user);
    $load_stmt->bindParam(1, $id);

    if (!$load_stmt->execute())
      throw new \Exception(sprintf('User #%s does not exist.', $id));

    if (!$load_stmt->fetch())
      throw new \Exception(sprintf('User #%s does not exist.', $id));

    return $user;
  }

  public function Create(LoginUser $user) {
    $insert_stmt = $this->app['db']->prepare("INSERT INTO users 
        (id, email, password, salt, name, roles, verificationKey) 
        VALUES 
        (NULL, ?, ?, ?, ?, ?, ?, ?)");

    $insert_stmt->bindParam(2, strtolower($user->email));
    $insert_stmt->bindParam(3, $user->password);
    $insert_stmt->bindParam(4, $user->salt);
    $insert_stmt->bindParam(5, $user->name);
    $insert_stmt->bindParam(6, implode(',', $user->roles));
    $insert_stmt->bindParam(7, $user->verificationKey);

    if (!$insert_stmt->execute()) {
      throw new \Exception("Unable to create user.");
    }

    $user->id = (int) $this->app['db']->lastInsertId();

    return $user;
  }

  public function Update(LoginUser $user) {
    $update_stmt = $this->app['db']->prepare("UPDATE users 
        SET email = ?, password = ?, salt = ?,
          name = ?, roles = ?, verificationKey = ?, enabled = ?
        WHERE id = ?");

    $update_stmt->bindParam(2, $user->email);
    $update_stmt->bindParam(3, $user->password);
    $update_stmt->bindParam(4, $user->salt);
    $update_stmt->bindParam(5, $user->name);
    $update_stmt->bindParam(6, $user->roles);
    $update_stmt->bindParam(7, $user->verificationKey);
    $update_stmt->bindParam(8, $user->enabled);
    $update_stmt->bindParam(9, $user->id);

    $result = $update_stmt->execute();

    if ($result == false) {
      throw new \Exception("Unable to update user.");
    }

    return $user;
  }

  public function Delete(LoginUser $user) {
    //TODO: Find use case & implement
  }

  public function NameIsUnique($name) {
    $name_stmt = $this->app['db']->prepare("SELECT name FROM users WHERE name LIKE ?");
    $name_stmt->bindParam(1, strtolower($name));

    if(!$name_stmt->execute()) {
      throw new \Exception(sprintf('Name %s is invalid', $name));
    }

    return $name_stmt->rowCount() == 0;
  }

  public function EmailExists($email) {
    $email_stmt = $this->app['db']->prepare("SELECT email FROM users WHERE email = ?");
    $email_stmt->bindParam(1, $email);

    if (!$email_stmt->execute()) {
      throw new \Exception(sprintf('Email "%s" is invalid', $email));
    }

    return $email_stmt->rowCount() == 1;
  }

  public function EmailIsUnique($email) {
    $email_stmt = $this->app['db']->prepare("SELECT email FROM users WHERE email = ? LIMIT 1");
    $email_stmt->bindParam(1, strtolower($email));

    if(!$email_stmt->execute()) {
      throw new \Exception(sprintf('Email %s is invalid', $email));
    }

    return $email_stmt->rowCount() == 0;
  }

  public function VerificationMatches($email, $verificationKey) {
    $verification_stmt = $this->app['db']->prepare("SELECT email, verificationKey FROM users WHERE email = ? AND verificationKey = ? LIMIT 1");
    $verification_stmt->bindParam(1, strtolower($email));
    $verification_stmt->bindParam(2, $verificationKey);

    if(!$verification_stmt->execute()) {
      throw new \Exception('Verification is invalid.');
    }

    return $verification_stmt->rowCount() == 1;
  }
}