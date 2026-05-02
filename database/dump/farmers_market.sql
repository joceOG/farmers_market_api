--
-- PostgreSQL database dump
--

\restrict gk0gCH2WlsB0ah6i1s2Xs6wWHeZMNQLEkPq8atMvq6JyVuhnSdRzqQe9645WY8S

-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_supervisor_id_foreign;
ALTER TABLE IF EXISTS ONLY public.transactions DROP CONSTRAINT IF EXISTS transactions_operator_id_foreign;
ALTER TABLE IF EXISTS ONLY public.transactions DROP CONSTRAINT IF EXISTS transactions_farmer_id_foreign;
ALTER TABLE IF EXISTS ONLY public.transaction_items DROP CONSTRAINT IF EXISTS transaction_items_transaction_id_foreign;
ALTER TABLE IF EXISTS ONLY public.transaction_items DROP CONSTRAINT IF EXISTS transaction_items_product_id_foreign;
ALTER TABLE IF EXISTS ONLY public.repayments DROP CONSTRAINT IF EXISTS repayments_operator_id_foreign;
ALTER TABLE IF EXISTS ONLY public.repayments DROP CONSTRAINT IF EXISTS repayments_farmer_id_foreign;
ALTER TABLE IF EXISTS ONLY public.repayment_debts DROP CONSTRAINT IF EXISTS repayment_debts_repayment_id_foreign;
ALTER TABLE IF EXISTS ONLY public.repayment_debts DROP CONSTRAINT IF EXISTS repayment_debts_debt_id_foreign;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_category_id_foreign;
ALTER TABLE IF EXISTS ONLY public.debts DROP CONSTRAINT IF EXISTS debts_transaction_id_foreign;
ALTER TABLE IF EXISTS ONLY public.debts DROP CONSTRAINT IF EXISTS debts_farmer_id_foreign;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_parent_id_foreign;
DROP INDEX IF EXISTS public.personal_access_tokens_tokenable_type_tokenable_id_index;
DROP INDEX IF EXISTS public.farmers_phone_index;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_username_unique;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.transactions DROP CONSTRAINT IF EXISTS transactions_pkey;
ALTER TABLE IF EXISTS ONLY public.transaction_items DROP CONSTRAINT IF EXISTS transaction_items_pkey;
ALTER TABLE IF EXISTS ONLY public.repayments DROP CONSTRAINT IF EXISTS repayments_pkey;
ALTER TABLE IF EXISTS ONLY public.repayment_debts DROP CONSTRAINT IF EXISTS repayment_debts_pkey;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_pkey;
ALTER TABLE IF EXISTS ONLY public.personal_access_tokens DROP CONSTRAINT IF EXISTS personal_access_tokens_token_unique;
ALTER TABLE IF EXISTS ONLY public.personal_access_tokens DROP CONSTRAINT IF EXISTS personal_access_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.password_reset_tokens DROP CONSTRAINT IF EXISTS password_reset_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.farmers DROP CONSTRAINT IF EXISTS farmers_pkey;
ALTER TABLE IF EXISTS ONLY public.farmers DROP CONSTRAINT IF EXISTS farmers_identifier_unique;
ALTER TABLE IF EXISTS ONLY public.failed_jobs DROP CONSTRAINT IF EXISTS failed_jobs_uuid_unique;
ALTER TABLE IF EXISTS ONLY public.failed_jobs DROP CONSTRAINT IF EXISTS failed_jobs_pkey;
ALTER TABLE IF EXISTS ONLY public.debts DROP CONSTRAINT IF EXISTS debts_pkey;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.transactions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.transaction_items ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.repayments ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.repayment_debts ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.products ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.migrations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.farmers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.failed_jobs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.debts ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.categories ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.transactions_id_seq;
DROP TABLE IF EXISTS public.transactions;
DROP SEQUENCE IF EXISTS public.transaction_items_id_seq;
DROP TABLE IF EXISTS public.transaction_items;
DROP SEQUENCE IF EXISTS public.repayments_id_seq;
DROP TABLE IF EXISTS public.repayments;
DROP SEQUENCE IF EXISTS public.repayment_debts_id_seq;
DROP TABLE IF EXISTS public.repayment_debts;
DROP SEQUENCE IF EXISTS public.products_id_seq;
DROP TABLE IF EXISTS public.products;
DROP SEQUENCE IF EXISTS public.personal_access_tokens_id_seq;
DROP TABLE IF EXISTS public.personal_access_tokens;
DROP TABLE IF EXISTS public.password_reset_tokens;
DROP SEQUENCE IF EXISTS public.migrations_id_seq;
DROP TABLE IF EXISTS public.migrations;
DROP SEQUENCE IF EXISTS public.farmers_id_seq;
DROP TABLE IF EXISTS public.farmers;
DROP SEQUENCE IF EXISTS public.failed_jobs_id_seq;
DROP TABLE IF EXISTS public.failed_jobs;
DROP SEQUENCE IF EXISTS public.debts_id_seq;
DROP TABLE IF EXISTS public.debts;
DROP SEQUENCE IF EXISTS public.categories_id_seq;
DROP TABLE IF EXISTS public.categories;
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    parent_id bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: debts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.debts (
    id bigint NOT NULL,
    transaction_id bigint NOT NULL,
    farmer_id bigint NOT NULL,
    original_amount numeric(12,2) NOT NULL,
    remaining_amount numeric(12,2) NOT NULL,
    status character varying(255) DEFAULT 'open'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT debts_status_check CHECK (((status)::text = ANY ((ARRAY['open'::character varying, 'partial'::character varying, 'paid'::character varying])::text[])))
);


--
-- Name: debts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.debts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: debts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.debts_id_seq OWNED BY public.debts.id;


--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: farmers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.farmers (
    id bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    firstname character varying(255) NOT NULL,
    lastname character varying(255) NOT NULL,
    phone character varying(255) NOT NULL,
    credit_limit numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    village character varying(255),
    region character varying(255)
);


--
-- Name: farmers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.farmers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: farmers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.farmers_id_seq OWNED BY public.farmers.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    price_fcfa numeric(12,2) NOT NULL,
    category_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: repayment_debts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repayment_debts (
    id bigint NOT NULL,
    repayment_id bigint NOT NULL,
    debt_id bigint NOT NULL,
    amount_applied numeric(12,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: repayment_debts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.repayment_debts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: repayment_debts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.repayment_debts_id_seq OWNED BY public.repayment_debts.id;


--
-- Name: repayments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repayments (
    id bigint NOT NULL,
    farmer_id bigint NOT NULL,
    operator_id bigint NOT NULL,
    kg_received numeric(10,3) NOT NULL,
    commodity_rate numeric(10,2) NOT NULL,
    fcfa_value numeric(12,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: repayments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.repayments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: repayments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.repayments_id_seq OWNED BY public.repayments.id;


--
-- Name: transaction_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transaction_items (
    id bigint NOT NULL,
    transaction_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(12,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: transaction_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transaction_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transaction_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transaction_items_id_seq OWNED BY public.transaction_items.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id bigint NOT NULL,
    farmer_id bigint NOT NULL,
    operator_id bigint NOT NULL,
    total_fcfa numeric(12,2) NOT NULL,
    payment_method character varying(255) NOT NULL,
    interest_rate numeric(5,4) DEFAULT '0'::numeric NOT NULL,
    credited_amount numeric(12,2),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT transactions_payment_method_check CHECK (((payment_method)::text = ANY ((ARRAY['cash'::character varying, 'credit'::character varying])::text[])))
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    username character varying(255) NOT NULL,
    role character varying(255) DEFAULT 'operator'::character varying NOT NULL,
    supervisor_id bigint
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: debts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debts ALTER COLUMN id SET DEFAULT nextval('public.debts_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: farmers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farmers ALTER COLUMN id SET DEFAULT nextval('public.farmers_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: repayment_debts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repayment_debts ALTER COLUMN id SET DEFAULT nextval('public.repayment_debts_id_seq'::regclass);


--
-- Name: repayments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repayments ALTER COLUMN id SET DEFAULT nextval('public.repayments_id_seq'::regclass);


--
-- Name: transaction_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_items ALTER COLUMN id SET DEFAULT nextval('public.transaction_items_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, name, parent_id, created_at, updated_at) FROM stdin;
1	Pesticides	\N	2026-05-02 10:26:25	2026-05-02 10:26:25
2	Engrais	\N	2026-05-02 10:26:25	2026-05-02 10:26:25
3	Semences	\N	2026-05-02 10:26:25	2026-05-02 10:26:25
4	Matériels	\N	2026-05-02 10:26:25	2026-05-02 10:26:25
5	Herbicides	1	2026-05-02 10:26:25	2026-05-02 10:26:25
6	Fongicides	1	2026-05-02 10:26:25	2026-05-02 10:26:25
7	Insecticides	1	2026-05-02 10:26:25	2026-05-02 10:26:25
8	Hematicides	1	2026-05-02 10:26:25	2026-05-02 10:26:25
9	Engrais Organiques	2	2026-05-02 10:26:25	2026-05-02 10:26:25
10	NPK (Nitrogène, Phosphore, Potasse)	2	2026-05-02 10:26:25	2026-05-02 10:26:25
11	Engrais Chimiques	2	2026-05-02 10:26:25	2026-05-02 10:26:25
12	Engrais Liquides Foliaires	2	2026-05-02 10:26:25	2026-05-02 10:26:25
13	Semences de Cacao	3	2026-05-02 10:26:25	2026-05-02 10:26:25
14	Semences de Café	3	2026-05-02 10:26:25	2026-05-02 10:26:25
15	Semences Légumes	3	2026-05-02 10:26:25	2026-05-02 10:26:25
16	Semences Céréales	3	2026-05-02 10:26:25	2026-05-02 10:26:25
17	Semences Oléagineux	3	2026-05-02 10:26:25	2026-05-02 10:26:25
18	Outils Agricoles	4	2026-05-02 10:26:25	2026-05-02 10:26:25
19	Équipements d'Irrigation	4	2026-05-02 10:26:25	2026-05-02 10:26:25
20	Équipements de Stockage	4	2026-05-02 10:26:25	2026-05-02 10:26:25
21	Petit Matériel Motorisé	4	2026-05-02 10:26:25	2026-05-02 10:26:25
\.


--
-- Data for Name: debts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.debts (id, transaction_id, farmer_id, original_amount, remaining_amount, status, created_at, updated_at) FROM stdin;
1	1	3	46800.00	46800.00	open	2026-05-02 10:26:25	2026-05-02 10:26:25
2	5	2	10400.00	10400.00	open	2026-05-02 21:54:14	2026-05-02 21:54:14
3	6	2	10400.00	10400.00	open	2026-05-02 21:54:17	2026-05-02 21:54:17
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: farmers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.farmers (id, identifier, firstname, lastname, phone, credit_limit, created_at, updated_at, village, region) FROM stdin;
1	F001	Jean	Koffi	07000000	50000.00	2026-04-30 21:36:06	2026-04-30 21:36:06	\N	\N
2	F002	KASONGO	BLE	07246623	60000.00	2026-05-02 00:42:13	2026-05-02 00:42:13	Bouake	Centre Bandamma
3	CI-2024-001	Kofi	Asante	+2250102030405	200000.00	2026-05-02 10:26:25	2026-05-02 10:26:25	\N	\N
4	CI-2024-002	Ama	Diallo	+2250607080910	150000.00	2026-05-02 10:26:25	2026-05-02 10:26:25	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	2014_10_12_000000_create_users_table	1
2	2014_10_12_100000_create_password_reset_tokens_table	1
3	2019_08_19_000000_create_failed_jobs_table	1
4	2019_12_14_000001_create_personal_access_tokens_table	1
5	2026_04_30_171918_update_users_add_username	1
6	2026_04_30_173126_create_farmers_table	2
7	2026_04_30_174648_add_role_and_supervisor_to_users_table	3
8	2026_04_30_213211_add_location_to_farmers	4
9	2026_04_30_213905_fix_users_remove_email_and_name	5
10	2026_05_01_154452_create_categories_table	6
11	2026_05_01_154452_create_products_table	7
12	2026_05_01_154452_create_transactions_table	8
13	2026_05_01_154453_create_repayments_table	9
14	2026_05_01_154452_create_debts_table	10
15	2026_05_01_154452_create_transaction_items_table	10
16	2026_05_01_154453_create_repayment_debts_table	10
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
26	App\\Models\\User	8	mobile	7bf78b0c0b55510695ae870440c38a5267504f79309113d0e32c9b2586cfc2ac	["*"]	2026-05-02 10:56:44	\N	2026-05-02 10:56:17	2026-05-02 10:56:44
1	App\\Models\\User	3	mobile	0200c517782e25e3731b8041c61ebd3788c8e93a8d33d31fa4c3f3d4b68cc05f	["*"]	2026-05-01 11:42:19	\N	2026-05-01 11:31:21	2026-05-01 11:42:19
2	App\\Models\\User	6	mobile	93998cb0f14b4b4e99b5b2bf07bb0b652e8ae0d63a607c5897dc3201b40aa1e1	["*"]	\N	\N	2026-05-01 12:16:17	2026-05-01 12:16:17
3	App\\Models\\User	3	mobile	95af8d3379f7c39b117be2dcac11c9e95066990a9287208fd1d37b96f669beb7	["*"]	\N	\N	2026-05-01 12:17:36	2026-05-01 12:17:36
4	App\\Models\\User	6	mobile	f06b78153ed88a4bcc11259dbf16980e6dc0bdfdf29efbc380e83b824051e48b	["*"]	\N	\N	2026-05-01 13:52:03	2026-05-01 13:52:03
5	App\\Models\\User	3	mobile	7f4c1ddbe1deb4c8a9525b6e9c8ba5692beff83e8de853a8d2be556bb96d5afd	["*"]	\N	\N	2026-05-01 13:52:41	2026-05-01 13:52:41
6	App\\Models\\User	3	mobile	75e6ab7f3b3ce8d48653f07e4b3efa8c5daf974fb0f361c75eea2da6808f35ed	["*"]	\N	\N	2026-05-01 15:29:46	2026-05-01 15:29:46
7	App\\Models\\User	6	mobile	485ad0f3a17f354a54c11b2003026bdcbd789a9cb2ebc8f73026e0516d4c3148	["*"]	\N	\N	2026-05-01 15:30:19	2026-05-01 15:30:19
8	App\\Models\\User	8	mobile	fa0187d207bee878bd9c89f757395b678b8e82c6d7002262da9d8e204d10bc47	["*"]	\N	\N	2026-05-01 18:25:09	2026-05-01 18:25:09
9	App\\Models\\User	8	mobile	01ef94d31c603034a067f99081c2690825754f72093ae2661d0b1cb342bdcbef	["*"]	\N	\N	2026-05-01 19:48:57	2026-05-01 19:48:57
10	App\\Models\\User	8	mobile	79b7f49d78a67cc46ec1ccd091f7917619891e2ccae2abfe30193dec513a6f7f	["*"]	2026-05-01 19:52:31	\N	2026-05-01 19:52:30	2026-05-01 19:52:31
11	App\\Models\\User	8	mobile	5f49402af3a0c1adf3c489a041709c8504c044da347d6f077c4ea5df897e3371	["*"]	2026-05-01 20:18:17	\N	2026-05-01 20:18:16	2026-05-01 20:18:17
27	App\\Models\\User	8	mobile	d1a3ed51b8fc7de1bf386f21ff91e047a1a0fc0675d61c161bc5a4f0dadba9a8	["*"]	2026-05-02 10:58:02	\N	2026-05-02 10:58:02	2026-05-02 10:58:02
12	App\\Models\\User	8	mobile	833470c260819015502760773be5b81eb8aa3c5197ac47b134daed74d6065949	["*"]	2026-05-01 23:26:40	\N	2026-05-01 23:20:00	2026-05-01 23:26:40
14	App\\Models\\User	8	mobile	7d00602d12400d02e5c20c67d77e002b757c0cfe99108ad8136936b77f1a4892	["*"]	2026-05-01 23:45:19	\N	2026-05-01 23:45:18	2026-05-01 23:45:19
15	App\\Models\\User	8	mobile	6b4b8f628b6eb43cae6a6d2899ea6689a5b6021915633634f04840cd1b442ef1	["*"]	2026-05-01 23:46:26	\N	2026-05-01 23:46:25	2026-05-01 23:46:26
16	App\\Models\\User	8	mobile	d3393ff383a300eddfd9dd7c84c01cb980f50e2aee55dbfeaaaed5b70f3faca1	["*"]	2026-05-01 23:47:34	\N	2026-05-01 23:47:34	2026-05-01 23:47:34
28	App\\Models\\User	8	mobile	11444d04e6b3a39dc3ee1d957a3156ba7c829fb827968d3ee26428f7d02b10cd	["*"]	2026-05-02 11:03:20	\N	2026-05-02 11:03:20	2026-05-02 11:03:20
22	App\\Models\\User	8	mobile	3d606a38b4b9ba1241ec7932925e4b8a1bb90989650afe17096b4f53e36fb1dd	["*"]	2026-05-02 00:48:50	\N	2026-05-02 00:40:31	2026-05-02 00:48:50
17	App\\Models\\User	8	mobile	4de4516359de41fdd12f34be1a343e7ad24a988162a52969c9e9355cc4893f3d	["*"]	2026-05-01 23:56:21	\N	2026-05-01 23:56:21	2026-05-01 23:56:21
18	App\\Models\\User	8	mobile	4ec4c1c246bc3fb5c8d1263b3de9c54a658431942f674667ec5c93330378f204	["*"]	2026-05-01 23:59:22	\N	2026-05-01 23:59:22	2026-05-01 23:59:22
19	App\\Models\\User	8	mobile	133b4fb4cabbd93494d01bd76b19460bfa6b9c4d0da6d33b265a4d6cf1536f04	["*"]	2026-05-02 00:09:51	\N	2026-05-02 00:09:51	2026-05-02 00:09:51
13	App\\Models\\User	8	mobile	f6b505e8c30969b7525981a73a950e2a4311e78357315f886f97c91c70a1c930	["*"]	2026-05-02 00:11:02	\N	2026-05-01 23:30:52	2026-05-02 00:11:02
20	App\\Models\\User	8	mobile	44a2d383c9e01a5170a1c75c4f3c47a2131b8f7dac1ec617e09e097c453c4e38	["*"]	2026-05-02 00:16:43	\N	2026-05-02 00:16:43	2026-05-02 00:16:43
21	App\\Models\\User	8	mobile	4a9df0d437722e7488ec62223770982e83c5efd91855579dd6c797d1eb495cc8	["*"]	2026-05-02 00:19:16	\N	2026-05-02 00:19:16	2026-05-02 00:19:16
37	App\\Models\\User	8	mobile	e923864579ce0cab04f91d72c9c27bab3d572a4a7265c9a956c53271e666ee1c	["*"]	2026-05-02 17:32:54	\N	2026-05-02 17:32:54	2026-05-02 17:32:54
23	App\\Models\\User	8	mobile	5bd677a4fb2ec41f9f4c1d4cfddeb4c72506cdb2c15177cf41830a315c72a0c3	["*"]	2026-05-02 09:45:58	\N	2026-05-02 09:44:41	2026-05-02 09:45:58
29	App\\Models\\User	8	mobile	dc3d2e7bdced071e6b783b2f651deafbf637dd683dbe3864e5612e85281b4946	["*"]	2026-05-02 11:11:13	\N	2026-05-02 11:10:54	2026-05-02 11:11:13
24	App\\Models\\User	3	mobile	8ca65ff7d10fec48b7986b16c51e5686b481c7eeec18b9e686379e3734d2ac22	["*"]	2026-05-02 10:52:18	\N	2026-05-02 09:46:13	2026-05-02 10:52:18
34	App\\Models\\User	8	mobile	61b81e438c66fc3af84c9c36d0e49b47e21fd9a4e5a5a365ce9a3dec6024ded5	["*"]	2026-05-02 13:14:53	\N	2026-05-02 13:14:23	2026-05-02 13:14:53
32	App\\Models\\User	8	mobile	3de4422f118abbb736c3a37ad98a74aeb2c3b2f11388f0f3e45a52420b9e3b18	["*"]	2026-05-02 11:41:30	\N	2026-05-02 11:40:54	2026-05-02 11:41:30
25	App\\Models\\User	8	mobile	e0654b7153052da8d25bd6fcf2c329315b68cb9b5603efdf41b86b94cab1f416	["*"]	2026-05-02 10:54:38	\N	2026-05-02 10:53:55	2026-05-02 10:54:38
30	App\\Models\\User	8	mobile	b238fe2a804e121fc43d3f9aa37ead923c2192078b7dbab226dbe16271d88bd8	["*"]	2026-05-02 11:27:57	\N	2026-05-02 11:16:00	2026-05-02 11:27:57
31	App\\Models\\User	3	mobile	6a7856a4ef2cf818701f5016b22bb1980fa8fd1cb3380f85650524483a10fb55	["*"]	2026-05-02 11:29:55	\N	2026-05-02 11:28:33	2026-05-02 11:29:55
38	App\\Models\\User	8	mobile	ed03b5048805239485a114a0f53e0bc52315b946d60a74d98fae22cca35256ef	["*"]	2026-05-02 17:58:02	\N	2026-05-02 17:58:02	2026-05-02 17:58:02
33	App\\Models\\User	8	mobile	0b206c1421c76bdcd375446827e8e569eda26303e9fd8eda69c5fe32aeea0c2b	["*"]	2026-05-02 13:13:10	\N	2026-05-02 13:12:53	2026-05-02 13:13:10
39	App\\Models\\User	8	mobile	54025d6bb17bfcb4bd79710fec82247556d8207384de11d020f19302e8e7f0a7	["*"]	2026-05-02 17:59:43	\N	2026-05-02 17:59:43	2026-05-02 17:59:43
36	App\\Models\\User	8	mobile	cd2dee4b535ff2561c5c7c31aad0378a4412a56e3458ea68cf345c58cccfa275	["*"]	2026-05-02 17:32:35	\N	2026-05-02 17:29:51	2026-05-02 17:32:35
35	App\\Models\\User	8	mobile	878ee6cf7b172e2d43bd515feda0bea5ede8e55555d62274823e0fa971da5b11	["*"]	2026-05-02 16:47:57	\N	2026-05-02 16:47:29	2026-05-02 16:47:57
41	App\\Models\\User	8	mobile	6d383d46d5222403c8c63646399750e8f6766a177e72d8a29b22b6cce2596ba3	["*"]	2026-05-02 18:28:03	\N	2026-05-02 18:28:03	2026-05-02 18:28:03
40	App\\Models\\User	8	mobile	1cb8d02c70578fa2a780beed8fd6aff7aa58988bd31aebd27b8bbed797824616	["*"]	2026-05-02 18:12:23	\N	2026-05-02 18:11:37	2026-05-02 18:12:23
42	App\\Models\\User	8	mobile	43f859b5865d4bdbaa807ed27479fd359e2a730ee8918f61fa55f12d8b6c62b0	["*"]	2026-05-02 18:29:16	\N	2026-05-02 18:29:16	2026-05-02 18:29:16
44	App\\Models\\User	8	mobile	6b72af87647ab578707140aa9cbcced02f96a650248030689ccc1dfd56a4b0d0	["*"]	2026-05-02 19:17:51	\N	2026-05-02 19:17:50	2026-05-02 19:17:51
43	App\\Models\\User	8	mobile	50b6354d865adbd5953078d6253ed0f470d8b33aeb5f4c9d8b8dd00354e19ee6	["*"]	2026-05-02 18:55:08	\N	2026-05-02 18:53:57	2026-05-02 18:55:08
45	App\\Models\\User	8	mobile	5bcd58ab7252b047549cb6868b5fdc18542edbcddcb7cdd0d0c508f8e0ad9d16	["*"]	2026-05-02 19:26:30	\N	2026-05-02 19:22:07	2026-05-02 19:26:30
46	App\\Models\\User	8	mobile	6d32eb36e188fc04a01f20ce230f048fb9e30cdca36a54961462e2371f9d6edb	["*"]	2026-05-02 19:45:29	\N	2026-05-02 19:45:22	2026-05-02 19:45:29
47	App\\Models\\User	8	mobile	caa7ffcf7d1f5e72dbe95dd16375df48067054301ee467a8d062e39dba281fd3	["*"]	2026-05-02 19:47:53	\N	2026-05-02 19:47:53	2026-05-02 19:47:53
55	App\\Models\\User	8	mobile	608901ddb6277aa5bd06173ec41cee9711661285737c934f45e0ede985f5ebc0	["*"]	2026-05-02 22:03:22	\N	2026-05-02 22:02:46	2026-05-02 22:03:22
48	App\\Models\\User	8	mobile	7ab45cdd82548c216b87d2c2284d278bcc034e8e8de94e828f048e9219cbc20e	["*"]	2026-05-02 19:53:46	\N	2026-05-02 19:52:53	2026-05-02 19:53:46
50	App\\Models\\User	3	mobile	778b5651d504d2614ecc74f9a7281e11c0b2ce7e798555106b7914600ee93b7d	["*"]	2026-05-02 22:07:07	\N	2026-05-02 21:04:14	2026-05-02 22:07:07
49	App\\Models\\User	8	mobile	2ba40bb26a5fbbfba99f284e12058294de7b0cbc2bd89d05d4f0fe5ce08b0efd	["*"]	2026-05-02 20:01:26	\N	2026-05-02 20:01:20	2026-05-02 20:01:26
51	App\\Models\\User	8	mobile	db44c61fd1236d912f450f8e4423ed215862b4580d153f4b5341f8b19b305c39	["*"]	2026-05-02 21:09:34	\N	2026-05-02 21:09:31	2026-05-02 21:09:34
52	App\\Models\\User	8	mobile	e6f098173214a2f491c2b9abac88af846a3abde51a1ed3ed30f37df01d270399	["*"]	2026-05-02 21:14:54	\N	2026-05-02 21:14:40	2026-05-02 21:14:54
56	App\\Models\\User	8	mobile	1ddeeb3817767ecf41260dce2ad961d49b73b80184b970fe244fda239bc69622	["*"]	2026-05-02 22:12:44	\N	2026-05-02 22:12:15	2026-05-02 22:12:44
53	App\\Models\\User	8	mobile	9d10e67873530fc47004cad694a0a41f49c73851b61edb30f97c7d19f4a41da6	["*"]	2026-05-02 21:49:06	\N	2026-05-02 21:49:03	2026-05-02 21:49:06
54	App\\Models\\User	8	mobile	db0aa4c51800ed5a662631e0a084dd1c63bd7e755b79966192c0c6adef9c0781	["*"]	2026-05-02 21:54:17	\N	2026-05-02 21:52:26	2026-05-02 21:54:17
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.products (id, name, description, price_fcfa, category_id, created_at, updated_at) FROM stdin;
1	Glyphosate 1L	Produit de qualité certifiée.	4500.00	5	2026-05-02 10:26:25	2026-05-02 10:26:25
2	Atrazine 500ml	Produit de qualité certifiée.	3200.00	5	2026-05-02 10:26:25	2026-05-02 10:26:25
3	Lambda-cyhalothrine	Produit de qualité certifiée.	5800.00	7	2026-05-02 10:26:25	2026-05-02 10:26:25
4	NPK 15-15-15 (50kg)	Produit de qualité certifiée.	18000.00	10	2026-05-02 10:26:25	2026-05-02 10:26:25
5	Urée 46% (50kg)	Produit de qualité certifiée.	15000.00	11	2026-05-02 10:26:25	2026-05-02 10:26:25
6	Compost Premium (25kg)	Produit de qualité certifiée.	8000.00	9	2026-05-02 10:26:25	2026-05-02 10:26:25
7	Semences Maïs hybride (5kg)	Produit de qualité certifiée.	12000.00	16	2026-05-02 10:26:25	2026-05-02 10:26:25
8	Semences Cacao Amelioré (1kg)	Produit de qualité certifiée.	9500.00	13	2026-05-02 10:26:25	2026-05-02 10:26:25
9	Pulvérisateur à dos 16L	Produit de qualité certifiée.	22000.00	21	2026-05-02 10:26:25	2026-05-02 10:26:25
10	Kit goutte-à-goutte	Produit de qualité certifiée.	35000.00	19	2026-05-02 10:26:25	2026-05-02 10:26:25
\.


--
-- Data for Name: repayment_debts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.repayment_debts (id, repayment_id, debt_id, amount_applied, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: repayments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.repayments (id, farmer_id, operator_id, kg_received, commodity_rate, fcfa_value, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: transaction_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transaction_items (id, transaction_id, product_id, quantity, unit_price, subtotal, created_at, updated_at) FROM stdin;
1	1	1	2	4500.00	9000.00	2026-05-02 10:26:25	2026-05-02 10:26:25
2	2	1	1	4500.00	4500.00	2026-05-02 17:31:17	2026-05-02 17:31:17
3	2	2	1	3200.00	3200.00	2026-05-02 17:31:17	2026-05-02 17:31:17
4	2	3	1	5800.00	5800.00	2026-05-02 17:31:17	2026-05-02 17:31:17
5	3	3	1	5800.00	5800.00	2026-05-02 19:22:58	2026-05-02 19:22:58
6	3	4	1	18000.00	18000.00	2026-05-02 19:22:58	2026-05-02 19:22:58
7	4	4	1	18000.00	18000.00	2026-05-02 19:53:13	2026-05-02 19:53:13
8	4	7	1	12000.00	12000.00	2026-05-02 19:53:13	2026-05-02 19:53:13
9	5	6	1	8000.00	8000.00	2026-05-02 21:54:14	2026-05-02 21:54:14
10	6	6	1	8000.00	8000.00	2026-05-02 21:54:17	2026-05-02 21:54:17
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transactions (id, farmer_id, operator_id, total_fcfa, payment_method, interest_rate, credited_amount, created_at, updated_at) FROM stdin;
1	3	6	36000.00	credit	0.3000	46800.00	2026-05-02 10:26:25	2026-05-02 10:26:25
2	2	8	13500.00	cash	0.0000	\N	2026-05-02 17:31:17	2026-05-02 17:31:17
3	1	8	23800.00	cash	0.0000	\N	2026-05-02 19:22:58	2026-05-02 19:22:58
4	4	8	30000.00	cash	0.0000	\N	2026-05-02 19:53:13	2026-05-02 19:53:13
5	2	8	8000.00	credit	0.3000	10400.00	2026-05-02 21:54:14	2026-05-02 21:54:14
6	2	8	8000.00	credit	0.3000	10400.00	2026-05-02 21:54:17	2026-05-02 21:54:17
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email_verified_at, password, remember_token, created_at, updated_at, username, role, supervisor_id) FROM stdin;
3	\N	$2y$12$alEA9k2YovwQ2U/wOyzu0.l.Qta4nmG5YujFnkovr7v7E38ie5bxK	\N	2026-04-30 21:42:37	2026-04-30 21:42:37	admin	admin	\N
4	\N	$2y$12$FDKlmDVv89ALyOl9s3lmWO1NnsBcIfyqq32PODktilxFBxPicmx86	\N	2026-04-30 21:45:32	2026-04-30 21:45:32	admin2	admin	\N
5	\N	$2y$12$KaffhOGRvTE7uyHvA/d36ORdmmmjmYWOKFDEuzgZEFzKU6pkJcKLS	\N	2026-04-30 21:46:00	2026-04-30 21:46:00	boss	supervisor	\N
6	\N	$2y$12$3OZtB2kcBAvuPSEFDMXhneMial1N9Ia6EsTRqrF58CUa4NGpTz8l6	\N	2026-04-30 21:46:18	2026-04-30 21:46:18	agent1	operator	5
8	\N	$2y$12$w.dgQiJ6rU63eAV4BOEO6uG.rjFSY/b0.lEynoV3wfW9aHYJQV/mu	\N	2026-05-01 18:18:39	2026-05-01 18:18:39	optest	operator	5
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 21, true);


--
-- Name: debts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.debts_id_seq', 3, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: farmers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.farmers_id_seq', 4, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.migrations_id_seq', 16, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 56, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.products_id_seq', 10, true);


--
-- Name: repayment_debts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.repayment_debts_id_seq', 1, false);


--
-- Name: repayments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.repayments_id_seq', 1, false);


--
-- Name: transaction_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transaction_items_id_seq', 10, true);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transactions_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: debts debts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debts
    ADD CONSTRAINT debts_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: farmers farmers_identifier_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farmers
    ADD CONSTRAINT farmers_identifier_unique UNIQUE (identifier);


--
-- Name: farmers farmers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farmers
    ADD CONSTRAINT farmers_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: repayment_debts repayment_debts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repayment_debts
    ADD CONSTRAINT repayment_debts_pkey PRIMARY KEY (id);


--
-- Name: repayments repayments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repayments
    ADD CONSTRAINT repayments_pkey PRIMARY KEY (id);


--
-- Name: transaction_items transaction_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_items
    ADD CONSTRAINT transaction_items_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: farmers_phone_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX farmers_phone_index ON public.farmers USING btree (phone);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: categories categories_parent_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_foreign FOREIGN KEY (parent_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: debts debts_farmer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debts
    ADD CONSTRAINT debts_farmer_id_foreign FOREIGN KEY (farmer_id) REFERENCES public.farmers(id) ON DELETE CASCADE;


--
-- Name: debts debts_transaction_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debts
    ADD CONSTRAINT debts_transaction_id_foreign FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE CASCADE;


--
-- Name: products products_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_foreign FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: repayment_debts repayment_debts_debt_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repayment_debts
    ADD CONSTRAINT repayment_debts_debt_id_foreign FOREIGN KEY (debt_id) REFERENCES public.debts(id) ON DELETE CASCADE;


--
-- Name: repayment_debts repayment_debts_repayment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repayment_debts
    ADD CONSTRAINT repayment_debts_repayment_id_foreign FOREIGN KEY (repayment_id) REFERENCES public.repayments(id) ON DELETE CASCADE;


--
-- Name: repayments repayments_farmer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repayments
    ADD CONSTRAINT repayments_farmer_id_foreign FOREIGN KEY (farmer_id) REFERENCES public.farmers(id) ON DELETE CASCADE;


--
-- Name: repayments repayments_operator_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repayments
    ADD CONSTRAINT repayments_operator_id_foreign FOREIGN KEY (operator_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: transaction_items transaction_items_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_items
    ADD CONSTRAINT transaction_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: transaction_items transaction_items_transaction_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_items
    ADD CONSTRAINT transaction_items_transaction_id_foreign FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE CASCADE;


--
-- Name: transactions transactions_farmer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_farmer_id_foreign FOREIGN KEY (farmer_id) REFERENCES public.farmers(id) ON DELETE CASCADE;


--
-- Name: transactions transactions_operator_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_operator_id_foreign FOREIGN KEY (operator_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_supervisor_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_supervisor_id_foreign FOREIGN KEY (supervisor_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict gk0gCH2WlsB0ah6i1s2Xs6wWHeZMNQLEkPq8atMvq6JyVuhnSdRzqQe9645WY8S

