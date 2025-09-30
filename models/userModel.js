import client from "../config/db.js";

// Find user by email
export const findUserByEmail = async (email) => {
    console.log('Email in model:', email);
    console.log('Pool in model:', client.query(
    "SELECT * FROM fairshare.users WHERE email = $1",
    [email]
  ));
  const result = await client.query(
    "SELECT * FROM fairshare.users WHERE email = $1",
    [email]
  );
  return result.rows[0];
};

// Create new user
export const createUser = async (username, email, passwordHash) => {
  const result = await client.query(
    `INSERT INTO fairshare.users (username, email, password_hash)
     VALUES ($1, $2, $3)
     RETURNING id, username, email`,
    [username, email, passwordHash]
    );
    console.log('New user created with ID:', result.rows[0])
    return result.rows[0];
    
};
