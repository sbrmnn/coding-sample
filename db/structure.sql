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
-- Name: api_errors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE api_errors (
    id integer NOT NULL,
    status character varying,
    response character varying,
    service character varying,
    function character varying,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: api_errors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE api_errors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE api_errors_id_seq OWNED BY api_errors.id;


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
    location character varying,
    core character varying,
    web character varying,
    mobile character varying,
    notes text,
    relationship_manager character varying,
    max_transfer_amount numeric(10,2) DEFAULT 25 NOT NULL,
    transfers_active boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    vendor_id integer
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
    savings_account_identifier character varying,
    savings_acct_balance numeric(10,2) DEFAULT 0 NOT NULL
);


--
-- Name: goal_statistics; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW goal_statistics AS
 SELECT goals.id AS goal_id,
    ((goals.balance * (100)::numeric) / goals.target_amount) AS percent_saved,
    (goals.target_amount - goals.balance) AS amount_left
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
    end_date timestamp without time zone,
    rule_id integer
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
    max_transfer_amount numeric(10,2) DEFAULT 25 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    vendor_access_token character varying
);


--
-- Name: historical_snapshot_stats; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW historical_snapshot_stats AS
 SELECT financial_institutions.id AS financial_institution_id,
    COALESCE(sum(transfers.amount), (0)::numeric) AS thirty_day_savings
   FROM ((financial_institutions
     LEFT JOIN users ON ((users.financial_institution_id = financial_institutions.id)))
     LEFT JOIN transfers ON ((transfers.user_id = users.id)))
  WHERE ((transfers.status = 'successful'::status) AND (transfers.end_date < now()))
  GROUP BY financial_institutions.id;


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
-- Name: recurring_transfer_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE recurring_transfer_rules (
    id integer NOT NULL,
    goal_id integer NOT NULL,
    amount character varying(50) NOT NULL,
    frequency character varying(10),
    repeats integer,
    start_dt timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT check_frequency CHECK (((frequency)::text = ANY (ARRAY[('day'::character varying)::text, ('week'::character varying)::text, ('month'::character varying)::text]))),
    CONSTRAINT check_repeat CHECK ((repeats = ANY (ARRAY[0, 1, 2, 3])))
);


--
-- Name: next_recurring_transfers; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW next_recurring_transfers AS
 WITH last_dt_table AS (
         SELECT t.rule_id,
            max(t.created_at) AS last_dt
           FROM transfers t,
            recurring_transfer_rules r
          WHERE ((t.status = 'successful'::status) AND (t.rule_id = r.id) AND (r.deleted_at IS NULL))
          GROUP BY t.rule_id
        ), all_rules AS (
         SELECT r.id,
            r.goal_id,
            r.repeats,
            r.frequency,
            r.start_dt
           FROM recurring_transfer_rules r,
            goals g
          WHERE ((g.id = r.goal_id) AND (r.deleted_at IS NULL))
        )
 SELECT a.id AS rule_id,
    a.goal_id,
    a.repeats,
    (
        CASE
            WHEN (l.last_dt IS NULL) THEN a.start_dt
            WHEN (l.last_dt > a.start_dt) THEN l.last_dt
            ELSE a.start_dt
        END + ((a.repeats || (a.frequency)::text))::interval) AS next_transfer
   FROM (all_rules a
     LEFT JOIN last_dt_table l ON ((l.rule_id = a.id)));


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
-- Name: recurring_transfer_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recurring_transfer_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recurring_transfer_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recurring_transfer_rules_id_seq OWNED BY recurring_transfer_rules.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: time_until_completions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW time_until_completions AS
 WITH prev_transfers_tb AS (
         SELECT transfers_in.user_id,
            transfer_out.amount,
            avg(transfers_in.diff) AS avg_days,
            avg(transfers_in.transfer_amount_attempted) AS avg_amount
           FROM ( SELECT DISTINCT ON (transfers.user_id) transfers.user_id,
                    transfers.amount
                   FROM transfers
                  ORDER BY transfers.user_id, transfers.id DESC) transfer_out,
            LATERAL ( SELECT transfers.user_id,
                    transfers.updated_at,
                    ((transfers.updated_at)::date - lag((transfers.updated_at)::date) OVER (ORDER BY transfers.updated_at)) AS diff,
                    transfers.transfer_amount_attempted
                   FROM transfers
                  WHERE (transfers.user_id = transfer_out.user_id)
                  ORDER BY transfers.updated_at DESC
                 LIMIT 3) transfers_in
          GROUP BY transfers_in.user_id, transfer_out.amount
        ), amount_to_complete AS (
         SELECT goals.id,
            goals.user_id,
            goals.xref_goal_type_id,
            goals.priority,
            rank() OVER (PARTITION BY goals.user_id ORDER BY goals.priority) AS rank_priority,
            (goals.target_amount - goals.balance) AS remaining
           FROM goals
          WHERE ((goals.target_amount - goals.balance) > (0)::numeric)
        )
 SELECT a.id AS goal_id,
    p.user_id,
    a.xref_goal_type_id,
    a.priority,
    p.amount,
        CASE
            WHEN (p.avg_days IS NULL) THEN (3)::numeric
            ELSE p.avg_days
        END AS avg_days,
        CASE
            WHEN (p.avg_amount IS NULL) THEN (
            CASE
                WHEN (p.amount > (50000)::numeric) THEN 10
                WHEN (p.amount > (10000)::numeric) THEN 8
                WHEN (p.amount > (5000)::numeric) THEN 6
                WHEN (p.amount > (500)::numeric) THEN 4
                ELSE 0
            END)::numeric
            ELSE p.avg_amount
        END AS avg_amount
   FROM prev_transfers_tb p,
    amount_to_complete a
  WHERE (p.user_id = a.user_id);


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
    date timestamp without time zone,
    sequence character varying
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
-- Name: vendor_user_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE vendor_user_keys (
    id integer NOT NULL,
    vendor_id integer,
    key character varying,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vendor_user_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vendor_user_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vendor_user_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vendor_user_keys_id_seq OWNED BY vendor_user_keys.id;


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
-- Name: view_vendor_users; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_vendor_users AS
 SELECT v.name,
    u.financial_institution_id,
    u.id AS user_id
   FROM vendors v,
    financial_institutions f,
    users u
  WHERE ((v.id = f.vendor_id) AND (f.id = u.financial_institution_id));


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
-- Name: api_errors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_errors ALTER COLUMN id SET DEFAULT nextval('api_errors_id_seq'::regclass);


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
-- Name: recurring_transfer_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recurring_transfer_rules ALTER COLUMN id SET DEFAULT nextval('recurring_transfer_rules_id_seq'::regclass);


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
-- Name: vendor_user_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vendor_user_keys ALTER COLUMN id SET DEFAULT nextval('vendor_user_keys_id_seq'::regclass);


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
-- Name: api_errors api_errors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_errors
    ADD CONSTRAINT api_errors_pkey PRIMARY KEY (id);


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
-- Name: recurring_transfer_rules recurring_transfer_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recurring_transfer_rules
    ADD CONSTRAINT recurring_transfer_rules_pkey PRIMARY KEY (id);


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
-- Name: vendor_user_keys vendor_user_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vendor_user_keys
    ADD CONSTRAINT vendor_user_keys_pkey PRIMARY KEY (id);


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
-- Name: index_api_errors_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_api_errors_on_user_id ON api_errors USING btree (user_id);


--
-- Name: index_bank_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bank_admins_on_email ON bank_admins USING btree (email);


--
-- Name: index_bank_admins_on_financial_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bank_admins_on_financial_institution_id ON bank_admins USING btree (financial_institution_id);


--
-- Name: index_bank_admins_on_token_and_token_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bank_admins_on_token_and_token_created_at ON bank_admins USING btree (token, token_created_at);


--
-- Name: index_demographics_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_demographics_on_user_id ON demographics USING btree (user_id);


--
-- Name: index_financial_institutions_on_vendor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_financial_institutions_on_vendor_id ON financial_institutions USING btree (vendor_id);


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
-- Name: index_offers_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_product_id ON offers USING btree (product_id);


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
-- Name: index_recurring_transfer_rules_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recurring_transfer_rules_on_deleted_at ON recurring_transfer_rules USING btree (deleted_at);


--
-- Name: index_recurring_transfer_rules_on_goal_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recurring_transfer_rules_on_goal_id ON recurring_transfer_rules USING btree (goal_id);


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
-- Name: index_users_on_financial_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_financial_institution_id ON users USING btree (financial_institution_id);


--
-- Name: index_vendor_user_keys_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendor_user_keys_on_user_id ON vendor_user_keys USING btree (user_id);


--
-- Name: index_vendor_user_keys_on_vendor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendor_user_keys_on_vendor_id ON vendor_user_keys USING btree (vendor_id);


--
-- Name: index_vendors_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vendors_on_email ON vendors USING btree (email);


--
-- Name: index_vendors_on_token_and_token_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendors_on_token_and_token_created_at ON vendors USING btree (token, token_created_at);


--
-- Name: unique_messages; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_messages ON messages USING btree (message_obj_id, message_obj_type, user_id);


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
('20171031061024'),
('20171031215220'),
('20171102035919'),
('20171102160911'),
('20171102160955'),
('20171105225028'),
('20171112045102'),
('20171117140039'),
('20171119210531'),
('20171121020210'),
('20171126025921'),
('20171126033613'),
('20171127222719'),
('20171203225536'),
('20171203225636'),
('20171203225708'),
('20171216201243'),
('20171217015239'),
('20171217015401'),
('20171217021928'),
('20171228170133'),
('20171228170243'),
('20171230053347'),
('20171230054020'),
('20171230054252'),
('20171230154246'),
('20171231043851'),
('20180101000322'),
('20180101003148'),
('20180101205327'),
('20180103024953'),
('20180103025133'),
('20180103025137'),
('20180104051629'),
('20180104051827'),
('20180105160340'),
('20180105171903'),
('20180105212035'),
('20180106161603'),
('20180106191258'),
('20180113001725'),
('20180113004329'),
('20180114022621'),
('20180115000934'),
('20180120213335'),
('20180121072949'),
('20180206164856'),
('20180212070432'),
('20180212072704'),
('20180213213955'),
('20180214005558'),
('20180214061600'),
('20180215055818'),
('20180215070202'),
('20180215221653'),
('20180216051711'),
('20180217013206'),
('20180228044257'),
('20180228074327'),
('20180228202033'),
('20180228212924'),
('20180301025423'),
('20180306193501'),
('20180309115031'),
('20180310182834'),
('20180413212425'),
('20180502202014');


