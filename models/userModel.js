import pool from "../db/index.js";

// Find user by email
export const findUserByEmail = async (email) => {
  const result = await pool.query(
    "SELECT * FROM fairshare.users WHERE email = $1",
    [email]
  );
  return result.rows[0];
};

// Create new user
export const createUser = async (username, email, passwordHash) => {
  const result = await pool.query(
    `INSERT INTO fairshare.users (username, email, password_hash)
     VALUES ($1, $2, $3)
     RETURNING id, username, email`,
    [username, email, passwordHash]
  );
  return result.rows[0];
};
