CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE fairshare.users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Indexes for faster lookups
CREATE INDEX idx_users_email ON users (email);

CREATE INDEX idx_users_username ON users (username);

-- Groups table
CREATE TABLE fairshare.groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    name VARCHAR(255) NOT NULL,
    created_by UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Group members
CREATE TABLE fairshare.group_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    group_id UUID NOT NULL REFERENCES fairshare.groups (id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES fairshare.users (id) ON DELETE CASCADE,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (group_id, user_id)
);

-- Expenses table
CREATE TABLE fairshare.expenses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    group_id UUID NOT NULL REFERENCES fairshare.groups (id) ON DELETE CASCADE,
    paid_by UUID NOT NULL REFERENCES fairshare.users (id) ON DELETE CASCADE,
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    currency CHAR(3) NOT NULL DEFAULT 'USD', -- ISO 4217 currency code
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Expense splits (who owes how much of an expense)
CREATE TABLE fairshare.expense_splits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    expense_id UUID NOT NULL REFERENCES fairshare.expenses (id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES fairshare.users (id) ON DELETE CASCADE,
    share_amount DECIMAL(10, 2) NOT NULL CHECK (share_amount >= 0),
    UNIQUE (expense_id, user_id) -- one share per user per expense
);

-- Settlements (when someone pays another to settle debts)
CREATE TABLE fairshare.settlements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    group_id UUID NOT NULL REFERENCES fairshare.groups (id) ON DELETE CASCADE,
    from_user UUID NOT NULL REFERENCES fairshare.users (id) ON DELETE CASCADE,
    to_user UUID NOT NULL REFERENCES fairshare.users (id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    currency CHAR(3) NOT NULL DEFAULT 'USD', -- ISO 4217 currency code
    settled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);