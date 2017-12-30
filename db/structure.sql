--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: ads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ads (
    id integer NOT NULL,
    financial_institution_id integer,
    header character varying NOT NULL,
    body text NOT NULL,
    link character varying NOT NULL,
    image character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying NOT NULL
);


--
-- Name: ads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ads_id_seq OWNED BY ads.id;


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
    AS integer
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
    AS integer
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
    AS integer
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
    tag character varying DEFAULT 'Other'::character varying,
    priority integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    target_amount numeric(10,2) DEFAULT 0 NOT NULL,
    balance numeric(10,2) DEFAULT 0 NOT NULL,
    xref_goal_type_id integer,
    savings_account_identifier character varying
);


--
-- Name: goal_statistics; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW goal_statistics AS
 SELECT goals.id AS goal_id,
    ((goals.balance * (100)::numeric) / goals.target_amount) AS percent_saved
   FROM goals;


--
-- Name: goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE goals_id_seq
    AS integer
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
-- Name: historical_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE historical_snapshots (
    id integer NOT NULL,
    financial_institution_id integer,
    average_user_balance numeric,
    sum_balance numeric,
    sum_message_clicks integer,
    total_messages integer,
    total_users integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date timestamp without time zone,
    total_num_of_goals integer DEFAULT 0,
    last_seven_days_user_signup integer DEFAULT 0,
    total_amount_of_completed_goals integer DEFAULT 0
);


--
-- Name: historical_snapshot_stats; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW historical_snapshot_stats AS
 SELECT financial_institutions.id AS financial_institution_id,
    COALESCE((max(hs.sum_balance) - min(hs.sum_balance)), (0)::numeric) AS thirty_day_savings
   FROM (financial_institutions
     LEFT JOIN historical_snapshots hs ON (((hs.financial_institution_id = financial_institutions.id) AND (hs.created_at > ((now())::date - 31)))))
  GROUP BY financial_institutions.id;


--
-- Name: historical_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE historical_snapshots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historical_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE historical_snapshots_id_seq OWNED BY historical_snapshots.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE messages (
    id integer NOT NULL,
    message_obj_id integer,
    message_obj_type character varying,
    user_id integer,
    clicks integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


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
    AS integer
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
-- Name: offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE offers (
    id integer NOT NULL,
    xref_goal_type_id integer,
    financial_institution_id integer,
    ad_id integer,
    condition character varying NOT NULL,
    symbol character varying(2) NOT NULL,
    value numeric(10,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    product_id integer
);


--
-- Name: offer_summaries; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW offer_summaries AS
 SELECT offers.id AS offer_id,
    count(messages.*) AS delivered,
    COALESCE(sum(messages.clicks), (0)::bigint) AS click_through
   FROM (offers
     LEFT JOIN messages ON (((messages.message_obj_id = offers.id) AND ((messages.message_obj_type)::text = 'Offer'::text))))
  GROUP BY offers.id;


--
-- Name: offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offers_id_seq OWNED BY offers.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE products (
    id integer NOT NULL,
    financial_institution_id integer,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    financial_institution_id integer NOT NULL,
    bank_user_id character varying NOT NULL,
    default_savings_account_identifier character varying NOT NULL,
    checking_account_identifier character varying NOT NULL,
    transfers_active boolean DEFAULT true,
    safety_net_active boolean DEFAULT true,
    max_transfer_amount numeric(10,2) DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    vendor_id integer
);


--
-- Name: snapshot_summaries; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW snapshot_summaries AS
 SELECT financial_institutions.id AS financial_institution_id,
    COALESCE(avg(goals.balance), (0)::numeric) AS average_user_balance,
    COALESCE(sum(goals.balance), (0)::numeric) AS sum_balance,
    COALESCE(sum(messages.clicks), (0)::bigint) AS sum_message_clicks,
    count(messages.*) AS total_messages,
    count(goals.*) AS total_num_of_goals,
    count(financial_institution_users.*) AS total_users,
    count(last_seven_days_user_signup.*) AS last_seven_days_user_signup,
    count(completed_goals_list.*) AS total_amount_of_completed_goals
   FROM (((((financial_institutions
     LEFT JOIN users financial_institution_users ON ((financial_institution_users.financial_institution_id = financial_institutions.id)))
     LEFT JOIN goals ON ((goals.user_id = financial_institution_users.id)))
     LEFT JOIN messages ON (((messages.user_id = financial_institution_users.id) AND ((messages.message_obj_type)::text = 'Offer'::text))))
     LEFT JOIN users last_seven_days_user_signup ON (((last_seven_days_user_signup.financial_institution_id = financial_institutions.id) AND (last_seven_days_user_signup.created_at > ((now())::date - 7)))))
     LEFT JOIN goal_statistics completed_goals_list ON (((completed_goals_list.goal_id = goals.id) AND (completed_goals_list.percent_saved >= (100)::numeric))))
  GROUP BY financial_institutions.id;


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
    AS integer
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
    AS integer
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
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    AS integer
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
-- Name: vendors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE vendors (
    id integer NOT NULL,
    name character varying,
    location character varying,
    core character varying,
    web character varying,
    mobile character varying,
    email character varying,
    notes text,
    relationship_manager character varying,
    password_digest character varying,
    token character varying,
    token_created_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vendors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vendors_id_seq OWNED BY vendors.id;


--
-- Name: xref_goal_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE xref_goal_types (
    id integer NOT NULL,
    code character varying,
    name character varying,
    department character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    financial_institution_id integer
);


--
-- Name: xref_goal_type_stats; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW xref_goal_type_stats AS
 SELECT xref_goal_types.id AS xref_goal_type_id,
    count(goals.*) AS total_num_of_goals
   FROM (xref_goal_types
     LEFT JOIN goals ON ((goals.xref_goal_type_id = xref_goal_types.id)))
  GROUP BY xref_goal_types.id;


--
-- Name: xref_goal_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE xref_goal_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xref_goal_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE xref_goal_types_id_seq OWNED BY xref_goal_types.id;


--
-- Name: ads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ads ALTER COLUMN id SET DEFAULT nextval('ads_id_seq'::regclass);


--
-- Name: bank_admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_admins ALTER COLUMN id SET DEFAULT nextval('bank_admins_id_seq'::regclass);


--
-- Name: demographics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY demographics ALTER COLUMN id SET DEFAULT nextval('demographics_id_seq'::regclass);


--
-- Name: financial_institutions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY financial_institutions ALTER COLUMN id SET DEFAULT nextval('financial_institutions_id_seq'::regclass);


--
-- Name: goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals ALTER COLUMN id SET DEFAULT nextval('goals_id_seq'::regclass);


--
-- Name: historical_snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY historical_snapshots ALTER COLUMN id SET DEFAULT nextval('historical_snapshots_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: monotto_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY monotto_users ALTER COLUMN id SET DEFAULT nextval('monotto_users_id_seq'::regclass);


--
-- Name: offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offers ALTER COLUMN id SET DEFAULT nextval('offers_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: transfers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfers ALTER COLUMN id SET DEFAULT nextval('transfers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: vendors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vendors ALTER COLUMN id SET DEFAULT nextval('vendors_id_seq'::regclass);


--
-- Name: xref_goal_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY xref_goal_types ALTER COLUMN id SET DEFAULT nextval('xref_goal_types_id_seq'::regclass);


--
-- Name: ads ads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: bank_admins bank_admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_admins
    ADD CONSTRAINT bank_admins_pkey PRIMARY KEY (id);


--
-- Name: demographics demographics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY demographics
    ADD CONSTRAINT demographics_pkey PRIMARY KEY (id);


--
-- Name: financial_institutions financial_institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY financial_institutions
    ADD CONSTRAINT financial_institutions_pkey PRIMARY KEY (id);


--
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);


--
-- Name: historical_snapshots historical_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY historical_snapshots
    ADD CONSTRAINT historical_snapshots_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: monotto_users monotto_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY monotto_users
    ADD CONSTRAINT monotto_users_pkey PRIMARY KEY (id);


--
-- Name: offers offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: xref_goal_types xref_goal_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY xref_goal_types
    ADD CONSTRAINT xref_goal_types_pkey PRIMARY KEY (id);


--
-- Name: index_ads_on_financial_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_financial_institution_id ON ads USING btree (financial_institution_id);


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
-- Name: index_historical_snapshots_on_financial_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_historical_snapshots_on_financial_institution_id ON historical_snapshots USING btree (financial_institution_id);


--
-- Name: index_messages_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_user_id ON messages USING btree (user_id);


--
-- Name: index_monotto_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_monotto_users_on_email ON monotto_users USING btree (email);


--
-- Name: index_monotto_users_on_token_and_token_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_monotto_users_on_token_and_token_created_at ON monotto_users USING btree (token, token_created_at);


--
-- Name: index_offers_on_ad_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_ad_id ON offers USING btree (ad_id);


--
-- Name: index_offers_on_financial_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_financial_institution_id ON offers USING btree (financial_institution_id);


--
-- Name: index_offers_on_xref_goal_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_xref_goal_type_id ON offers USING btree (xref_goal_type_id);


--
-- Name: index_products_on_financial_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_financial_institution_id ON products USING btree (financial_institution_id);


--
-- Name: index_products_on_name_and_financial_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_products_on_name_and_financial_institution_id ON products USING btree (name, financial_institution_id);


--
-- Name: index_transactions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_user_id ON transactions USING btree (user_id);


--
-- Name: index_transfers_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transfers_on_user_id ON transfers USING btree (user_id);


--
-- Name: index_users_on_bank_user_id_and_financial_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_bank_user_id_and_financial_institution_id ON users USING btree (bank_user_id, financial_institution_id);


--
-- Name: index_users_on_bank_user_id_and_vendor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_bank_user_id_and_vendor_id ON users USING btree (bank_user_id, vendor_id);


--
-- Name: index_users_on_financial_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_financial_institution_id ON users USING btree (financial_institution_id);


--
-- Name: index_vendors_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendors_on_email ON vendors USING btree (email);


--
-- Name: index_vendors_on_token_and_token_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendors_on_token_and_token_created_at ON vendors USING btree (token, token_created_at);


--
-- Name: offers fk_rails_009136a4eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT fk_rails_009136a4eb FOREIGN KEY (financial_institution_id) REFERENCES financial_institutions(id);


--
-- Name: bank_admins fk_rails_2047acc645; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_admins
    ADD CONSTRAINT fk_rails_2047acc645 FOREIGN KEY (financial_institution_id) REFERENCES financial_institutions(id);


--
-- Name: transfers fk_rails_344b52b7fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfers
    ADD CONSTRAINT fk_rails_344b52b7fd FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: offers fk_rails_44583af250; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT fk_rails_44583af250 FOREIGN KEY (ad_id) REFERENCES ads(id);


--
-- Name: products fk_rails_57a880a289; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT fk_rails_57a880a289 FOREIGN KEY (financial_institution_id) REFERENCES financial_institutions(id);


--
-- Name: transactions fk_rails_77364e6416; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT fk_rails_77364e6416 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: goals fk_rails_c5fd9c8a38; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT fk_rails_c5fd9c8a38 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: demographics fk_rails_dd13be0cc8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY demographics
    ADD CONSTRAINT fk_rails_dd13be0cc8 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: ads fk_rails_ed15292327; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ads
    ADD CONSTRAINT fk_rails_ed15292327 FOREIGN KEY (financial_institution_id) REFERENCES financial_institutions(id);


--
-- Name: users fk_rails_eeccee8915; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_eeccee8915 FOREIGN KEY (financial_institution_id) REFERENCES financial_institutions(id);


--
-- Name: goals fk_rails_f2dc556d45; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT fk_rails_f2dc556d45 FOREIGN KEY (xref_goal_type_id) REFERENCES xref_goal_types(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

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
('20171020080605'),
('20171020080817'),
('20171022195809'),
('20171022195906'),
('20171022200829'),
('20171025042111'),
('20171026154033'),
('20171026154034'),
('20171029050448'),
('20171030042401'),
('20171031032104'),
('20171031061024'),
('20171031215220'),
('20171102035919'),
('20171102160911'),
('20171102160955'),
('20171105225028'),
('20171112045102'),
('20171117140039'),
('20171119210531'),
('20171120050231'),
('20171121020210'),
('20171126022622'),
('20171126025921'),
('20171126033613'),
('20171127222719'),
('20171128133347'),
('20171203225536'),
('20171203225636'),
('20171203225708'),
('20171216201243'),
('20171216203030'),
('20171217015239'),
('20171217015401'),
('20171217021928'),
('20171228170133'),
('20171228170243'),
('20171230053347'),
('20171230054020'),
('20171230054052'),
('20171230054252');


