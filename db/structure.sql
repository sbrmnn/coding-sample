--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.2
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE status AS ENUM (
    'successful',
    'pending',
    'failed'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bank_admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bank_admins (
    id integer NOT NULL,
    financial_institution_id integer NOT NULL,
    email character varying NOT NULL,
    name character varying NOT NULL,
    title character varying NOT NULL,
    phone character varying NOT NULL,
    notes text,
    is_primary boolean DEFAULT false,
    password_digest character varying,
    token character varying,
    token_created_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bank_admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bank_admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bank_admins_id_seq OWNED BY bank_admins.id;


--
-- Name: demographics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE demographics (
    id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: demographics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demographics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: demographics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demographics_id_seq OWNED BY demographics.id;


--
-- Name: financial_institutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE financial_institutions (
    id integer NOT NULL,
    name character varying NOT NULL,
    location character varying NOT NULL,
    core character varying,
    web character varying,
    mobile character varying,
    notes text,
    relationship_manager character varying,
    max_transfer_amount numeric(10,2) DEFAULT 0 NOT NULL,
    transfers_active boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: financial_institutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE financial_institutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: financial_institutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE financial_institutions_id_seq OWNED BY financial_institutions.id;


--
-- Name: goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE goals (
    id integer NOT NULL,
    user_id integer NOT NULL,
    type character varying NOT NULL,
    tag character varying DEFAULT 'Other'::character varying,
    priority integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    target_amount numeric(10,2) DEFAULT 0 NOT NULL,
    collection numeric(10,2) DEFAULT 0 NOT NULL
);


--
-- Name: goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE goals_id_seq OWNED BY goals.id;


--
-- Name: monotto_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE monotto_users (
    id integer NOT NULL,
    email character varying NOT NULL,
    name character varying,
    password_digest character varying,
    token character varying,
    token_created_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: monotto_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE monotto_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monotto_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE monotto_users_id_seq OWNED BY monotto_users.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transactions (
    id bigint NOT NULL,
    original_description text,
    split_type text,
    category text,
    currency character varying(1),
    amount numeric(10,2) DEFAULT 0 NOT NULL,
    user_description text,
    memo text,
    classification text,
    account_name text,
    simple_description text,
    user_id integer,
    balance numeric(10,2) DEFAULT 0 NOT NULL,
    date date
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: transfers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transfers (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    origin_account character varying NOT NULL,
    destination_account character varying NOT NULL,
    amount numeric(10,2) DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    transfer_amount_attempted numeric(10,2),
    next_transfer_date date,
    status status,
    end_date timestamp without time zone
);


--
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transfers_id_seq OWNED BY transfers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    financial_institution_id integer NOT NULL,
    sequence character varying NOT NULL,
    bank_user_id character varying NOT NULL,
    savings_account_identifier character varying NOT NULL,
    checking_account_identifier character varying NOT NULL,
    transfers_active boolean DEFAULT true,
    safety_net_active boolean DEFAULT true,
    max_transfer_amount numeric(10,2) DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_admins ALTER COLUMN id SET DEFAULT nextval('bank_admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY demographics ALTER COLUMN id SET DEFAULT nextval('demographics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY financial_institutions ALTER COLUMN id SET DEFAULT nextval('financial_institutions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals ALTER COLUMN id SET DEFAULT nextval('goals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY monotto_users ALTER COLUMN id SET DEFAULT nextval('monotto_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfers ALTER COLUMN id SET DEFAULT nextval('transfers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: bank_admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_admins
    ADD CONSTRAINT bank_admins_pkey PRIMARY KEY (id);


--
-- Name: demographics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY demographics
    ADD CONSTRAINT demographics_pkey PRIMARY KEY (id);


--
-- Name: financial_institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY financial_institutions
    ADD CONSTRAINT financial_institutions_pkey PRIMARY KEY (id);


--
-- Name: goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);


--
-- Name: monotto_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY monotto_users
    ADD CONSTRAINT monotto_users_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_bank_admins_on_financial_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bank_admins_on_financial_institution_id ON bank_admins USING btree (financial_institution_id);


--
-- Name: index_bank_admins_on_financial_institution_id_and_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bank_admins_on_financial_institution_id_and_email ON bank_admins USING btree (financial_institution_id, email);


--
-- Name: index_bank_admins_on_token_and_token_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bank_admins_on_token_and_token_created_at ON bank_admins USING btree (token, token_created_at);


--
-- Name: index_demographics_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_demographics_on_user_id ON demographics USING btree (user_id);


--
-- Name: index_goals_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_goals_on_user_id ON goals USING btree (user_id);


--
-- Name: index_goals_on_user_id_and_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_goals_on_user_id_and_priority ON goals USING btree (user_id, priority);


--
-- Name: index_goals_on_user_id_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_goals_on_user_id_and_type ON goals USING btree (user_id, type);


--
-- Name: index_monotto_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_monotto_users_on_email ON monotto_users USING btree (email);


--
-- Name: index_monotto_users_on_token_and_token_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_monotto_users_on_token_and_token_created_at ON monotto_users USING btree (token, token_created_at);


--
-- Name: index_transactions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_user_id ON transactions USING btree (user_id);


--
-- Name: index_transfers_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transfers_on_user_id ON transfers USING btree (user_id);


--
-- Name: index_users_on_financial_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_financial_institution_id ON users USING btree (financial_institution_id);


--
-- Name: index_users_on_financial_institution_id_and_bank_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_financial_institution_id_and_bank_user_id ON users USING btree (financial_institution_id, bank_user_id);


--
-- Name: fk_rails_2047acc645; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_admins
    ADD CONSTRAINT fk_rails_2047acc645 FOREIGN KEY (financial_institution_id) REFERENCES financial_institutions(id);


--
-- Name: fk_rails_344b52b7fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfers
    ADD CONSTRAINT fk_rails_344b52b7fd FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_77364e6416; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT fk_rails_77364e6416 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_c5fd9c8a38; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT fk_rails_c5fd9c8a38 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_dd13be0cc8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY demographics
    ADD CONSTRAINT fk_rails_dd13be0cc8 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_eeccee8915; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_eeccee8915 FOREIGN KEY (financial_institution_id) REFERENCES financial_institutions(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO "schema_migrations" (version) VALUES
('20170314005938'),
('20170314005949'),
('20170314005959'),
('20170314010026'),
('20170314010245'),
('20170314010335'),
('20170319184311'),
('20170407044932'),
('20170407045010'),
('20170407045043'),
('20170407045337'),
('20170407045458'),
('20170407045631'),
('20170409192406'),
('20170409193602'),
('20170610221559'),
('20170811180844'),
('20170811183906'),
('20170811184345'),
('20170812002630'),
('20170812010449'),
('20170812011852'),
('20170812012435'),
('20170818203744'),
('20170819030439'),
('20170819030722'),
('20170821031656'),
('20170821031905'),
('20170821032204'),
('20170821032510'),
('20170822164027'),
('20170822164101'),
('20170824212310'),
('20171020075643'),
('20171020075858'),
('20171020075953'),
('20171020080155'),
('20171020080604'),
('20171020080817');


