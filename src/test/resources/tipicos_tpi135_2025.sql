

CREATE SEQUENCE public.combo_id_combo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.combo_id_combo_seq OWNER TO postgres;

CREATE TABLE public.combo (
                              id_combo bigint NOT NULL  DEFAULT nextval('combo_id_combo_seq'),
                              nombre character varying(155),
                              activo boolean,
                              descripcion_publica text,
                              url text
);


ALTER TABLE public.combo OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 25334)
-- Name: combo_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.combo_detalle (
                                      id_combo bigint NOT NULL,
                                      id_producto bigint NOT NULL,
                                      cantidad integer DEFAULT 1,
                                      activo boolean
);


ALTER TABLE public.combo_detalle OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 25319)
-- Name: orden; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden (
                              id_orden bigint NOT NULL,
                              fecha date DEFAULT now(),
                              sucursal character varying(5),
                              anulada boolean DEFAULT false
);


ALTER TABLE public.orden OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 25352)
-- Name: orden_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden_detalle (
                                      id_orden bigint NOT NULL,
                                      id_producto_precio bigint NOT NULL,
                                      cantidad integer DEFAULT 1 NOT NULL,
                                      precio numeric(6,2),
                                      observaciones text
);


ALTER TABLE public.orden_detalle OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25318)
-- Name: orden_id_orden_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orden_id_orden_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orden_id_orden_seq OWNER TO postgres;

--
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 222
-- Name: orden_id_orden_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orden_id_orden_seq OWNED BY public.orden.id_orden;


--
-- TOC entry 228 (class 1259 OID 25371)
-- Name: pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pago (
                             id_pago bigint NOT NULL,
                             id_orden bigint,
                             fecha date DEFAULT now(),
                             metodo_pago character varying(10) DEFAULT 'EFECTIVO'::character varying,
                             referencia text
);


ALTER TABLE public.pago OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 25387)
-- Name: pago_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pago_detalle (
                                     id_pago_detalle bigint NOT NULL,
                                     id_pago bigint,
                                     monto numeric(6,2),
                                     observaciones text
);


ALTER TABLE public.pago_detalle OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25386)
-- Name: pago_detalle_id_pago_detalle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pago_detalle_id_pago_detalle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pago_detalle_id_pago_detalle_seq OWNER TO postgres;

--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 229
-- Name: pago_detalle_id_pago_detalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pago_detalle_id_pago_detalle_seq OWNED BY public.pago_detalle.id_pago_detalle;


--
-- TOC entry 227 (class 1259 OID 25370)
-- Name: pago_id_pago_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pago_id_pago_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pago_id_pago_seq OWNER TO postgres;

--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 227
-- Name: pago_id_pago_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pago_id_pago_seq OWNED BY public.pago.id_pago;


--
-- TOC entry 218 (class 1259 OID 25278)
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
                                 id_producto bigint NOT NULL,
                                 nombre character varying(155),
                                 activo boolean DEFAULT true,
                                 observaciones text,
                                 url text
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE producto; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.producto IS 'Productos disponibles para consumo';


--
-- TOC entry 219 (class 1259 OID 25287)
-- Name: producto_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto_detalle (
                                         id_tipo_producto integer NOT NULL,
                                         id_producto bigint NOT NULL,
                                         activo boolean DEFAULT true,
                                         observaciones text
);


ALTER TABLE public.producto_detalle OWNER TO postgres;

--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE producto_detalle; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.producto_detalle IS 'Determina los tipos de producto que aplican para un producto';


--
-- TOC entry 217 (class 1259 OID 25277)
-- Name: producto_id_producto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_id_producto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_id_producto_seq OWNER TO postgres;

--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 217
-- Name: producto_id_producto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_id_producto_seq OWNED BY public.producto.id_producto;


--
-- TOC entry 221 (class 1259 OID 25306)
-- Name: producto_precio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto_precio (
                                        id_producto_precio bigint NOT NULL,
                                        id_producto bigint,
                                        fecha_desde date DEFAULT now(),
                                        fecha_hasta date,
                                        precio_sugerido numeric(8,2)
);


ALTER TABLE public.producto_precio OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 25305)
-- Name: producto_precio_id_producto_precio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_precio_id_producto_precio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_precio_id_producto_precio_seq OWNER TO postgres;

--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 220
-- Name: producto_precio_id_producto_precio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_precio_id_producto_precio_seq OWNED BY public.producto_precio.id_producto_precio;


--
-- TOC entry 216 (class 1259 OID 25268)
-- Name: tipo_producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_producto (
                                      id_tipo_producto integer NOT NULL,
                                      nombre character varying(155) NOT NULL,
                                      activo boolean DEFAULT true,
                                      observaciones text
);


ALTER TABLE public.tipo_producto OWNER TO postgres;

--
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE tipo_producto; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.tipo_producto IS 'Califica los tipos de productos';


--
-- TOC entry 215 (class 1259 OID 25267)
-- Name: tipo_producto_id_tipo_producto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_producto_id_tipo_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_producto_id_tipo_producto_seq OWNER TO postgres;

--
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 215
-- Name: tipo_producto_id_tipo_producto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_producto_id_tipo_producto_seq OWNED BY public.tipo_producto.id_tipo_producto;


--
-- TOC entry 3294 (class 2604 OID 25322)
-- Name: orden id_orden; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden ALTER COLUMN id_orden SET DEFAULT nextval('public.orden_id_orden_seq'::regclass);


--
-- TOC entry 3299 (class 2604 OID 25374)
-- Name: pago id_pago; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago ALTER COLUMN id_pago SET DEFAULT nextval('public.pago_id_pago_seq'::regclass);


--
-- TOC entry 3302 (class 2604 OID 25390)
-- Name: pago_detalle id_pago_detalle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago_detalle ALTER COLUMN id_pago_detalle SET DEFAULT nextval('public.pago_detalle_id_pago_detalle_seq'::regclass);


--
-- TOC entry 3289 (class 2604 OID 25281)
-- Name: producto id_producto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto ALTER COLUMN id_producto SET DEFAULT nextval('public.producto_id_producto_seq'::regclass);


--
-- TOC entry 3292 (class 2604 OID 25309)
-- Name: producto_precio id_producto_precio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_precio ALTER COLUMN id_producto_precio SET DEFAULT nextval('public.producto_precio_id_producto_precio_seq'::regclass);


--
-- TOC entry 3287 (class 2604 OID 25271)
-- Name: tipo_producto id_tipo_producto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_producto ALTER COLUMN id_tipo_producto SET DEFAULT nextval('public.tipo_producto_id_tipo_producto_seq'::regclass);


--
-- TOC entry 3486 (class 0 OID 25327)
-- Dependencies: 224
-- Data for Name: combo; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3487 (class 0 OID 25334)
-- Dependencies: 225
-- Data for Name: combo_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3485 (class 0 OID 25319)
-- Dependencies: 223
-- Data for Name: orden; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3488 (class 0 OID 25352)
-- Dependencies: 226
-- Data for Name: orden_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3490 (class 0 OID 25371)
-- Dependencies: 228
-- Data for Name: pago; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3492 (class 0 OID 25387)
-- Dependencies: 230
-- Data for Name: pago_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3480 (class 0 OID 25278)
-- Dependencies: 218
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3481 (class 0 OID 25287)
-- Dependencies: 219
-- Data for Name: producto_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3483 (class 0 OID 25306)
-- Dependencies: 221
-- Data for Name: producto_precio; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3478 (class 0 OID 25268)
-- Dependencies: 216
-- Data for Name: tipo_producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_producto VALUES (1001, 'bebida', true, NULL);
INSERT INTO public.tipo_producto VALUES (1002, 'comida', true, NULL);
INSERT INTO public.tipo_producto VALUES (1003, 'tipicos', true, NULL);

INSERT INTO public.producto VALUES (1001, 'coca 1.25L', true, NULL,'https://cdn.pedix.app/lJ0himepqTJcT1Ynn5lP/products/1718493289062-24927.png?size=2000x2000');
INSERT INTO public.producto VALUES (1002, 'pepsi', true, NULL,'https://farinapizzas.com.au/wp-content/uploads/2023/05/1.25L-Pepsi.jpg');
INSERT INTO public.producto VALUES (1003, 'pupusas', true,null ,'https://imag.bonviveur.com/pupusas-salvadorenas.webp');
INSERT INTO public.producto VALUES (1004, 'nuegados', false, NULL,'https://www.tipicosmargoth.com/wp-content/uploads/2020/05/NU%C3%89GADO-DE-YUCA-TIPICOS-MARGOTH.jpg');
INSERT INTO public.producto VALUES (1005, 'yuca frita', true, NULL,'https://mojo.generalmills.com/api/public/content/dIC2MOZgzUy11gV3XUty4g_gmi_hi_res_jpeg.jpeg?v=1b8cbe0c&t=16e3ce250f244648bef28c5949fb99ff');
INSERT INTO public.producto VALUES (1006, 'chilate', true, NULL,'https://scontent.fsal2-2.fna.fbcdn.net/v/t1.6435-9/126903013_1324003161281913_2395096843591853983_n.jpg?stp=dst-jpg_s600x600_tt6&_nc_cat=110&ccb=1-7&_nc_sid=833d8c&_nc_ohc=xMvTpJKNmBEQ7kNvwHNLIh3&_nc_oc=AdniETChzLvoW-st65gATZU2-Yyq-CchCP5mBOsOIUNjQBp4awcBpwZ1YCVUnSBpNa0WnwjhWaTRr8yU1ZetPJmf&_nc_zt=23&_nc_ht=scontent.fsal2-2.fna&_nc_gid=U6oH-84yWomciF_IiYbXpw&oh=00_AfGPNqJ5-I-11oAFO749eCb2DU6hLVxmibgyOBQpnWsz7g&oe=683C7064');
INSERT INTO public.producto VALUES (1007, 'tamal de maiz', true, NULL,'https://www.correo.ca/wp-content/uploads/2023/06/Tamales-colombianosshutterstock_2045038238-696x464.jpeg');
INSERT INTO public.producto VALUES (1008, 'tamal de elote', true, NULL,'https://editorialtelevisa.brightspotcdn.com/dims4/default/a8975df/2147483647/strip/true/crop/900x507+0+47/resize/1000x563!/format/webp/quality/90/?url=https%3A%2F%2Fk2-prod-editorial-televisa.s3.us-east-1.amazonaws.com%2Fbrightspot%2Fwp-content%2Fuploads%2F2021%2F07%2Ftamales.jpg');
INSERT INTO public.producto VALUES (1009, 'empanadas de platano', true, NULL,'https://scontent.fsal2-1.fna.fbcdn.net/v/t1.6435-9/66315240_2055458884558069_7533554039422713856_n.jpg?stp=dst-jpg_s600x600_tt6&_nc_cat=100&ccb=1-7&_nc_sid=833d8c&_nc_ohc=ZuqDvh5wpLYQ7kNvwFsjMPq&_nc_oc=AdnzTCmNG56ItSDyHZAQr0M5Y1_x4UkNVx5sRBnG1wt8SMdu1Ur4bFcgizC8ie_lSVbRI-Vg8QcNJjjzp2y468_5&_nc_zt=23&_nc_ht=scontent.fsal2-1.fna&_nc_gid=NNn6M4-lTMTwdRvjwfqdQQ&oh=00_AfFvdF4G0xVrQQWdEIhCe4kQgjiJKClxfih-yBkzG2bEYA&oe=683C6209');
INSERT INTO public.producto VALUES (1010, 'riguas', true, NULL,'https://www.tipicosmargoth.com/wp-content/uploads/2020/05/RIGUAS-TIPICOS-MARGOTH.jpg');
INSERT INTO public.producto VALUES (1011, 'casamiento', true, NULL,'https://www.recetassalvador.com/base/stock/Recipe/casamiento/casamiento_web.jpg.webp');
INSERT INTO public.producto VALUES (1012, 'cafe', true, NULL,'https://static.elmundo.sv/wp-content/uploads/2020/08/Cafe1.jpg');
INSERT INTO public.producto VALUES (1013, 'chocolate', true, NULL,'https://images.squarespace-cdn.com/content/v1/629687d754ac3a7c9d6de4f9/f3b4c260-44be-4a37-b604-3e200f309116/ya_DSC0583.jpg');
INSERT INTO public.producto VALUES (1014, 'atol', true, NULL,'https://cdn-pro.elsalvador.com/wp-content/uploads/2019/01/Atol-de-maiz.jpg');
INSERT INTO public.producto VALUES (1015, 'frijoles fritos', true, NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMZpYhPkJ4xwoDi02T9_Ds3DkC3-_BWKr0LA&s');
INSERT INTO public.producto VALUES (1016, 'queso fresco', true, NULL,'https://i.ytimg.com/vi/ElD931s_Vgs/sddefault.jpg');
INSERT INTO public.producto VALUES (1017, 'crema', true, NULL,'https://walmartsv.vtexassets.com/arquivos/ids/274677/Crema-Salud-Bolsa-750Ml-1-14861.jpg?v=638025251119530000');
INSERT INTO public.producto VALUES (1018, 'horchata', true, NULL,'https://i.pinimg.com/736x/84/5c/16/845c16967a40214e0d83fd25f9954fbc.jpg');
INSERT INTO public.producto VALUES (1019, 'platanos fritos', true, NULL,'https://lh4.googleusercontent.com/proxy/tL2W2GwdL5zOstTl8ROvwZSgB4xf9Yi1vU8vpW_ZBeOa67JJIbWgenrLUqH3dwlL_Q_6ZoBjtsFHwb_q96TRUVCTASfIOjNf4_ck6q0x-h7V54hfl452iJDS0NG4PQ');
INSERT INTO public.producto VALUES (1020, 'huevos revueltos', true, NULL,'https://www.divinacocina.es/wp-content/uploads/2016/01/huevos-revueltos-para-desayunos-sarten.jpg');


INSERT INTO public.producto_precio VALUES (1001,1001 ,'2025-01-01',  '2030-12-31',1.50);
INSERT INTO public.producto_precio VALUES (1002,1002 ,'2025-01-01',  '2030-12-31',1.50);
INSERT INTO public.producto_precio VALUES (1003,1003 ,'2025-01-01',  '2030-12-31',0.80);
INSERT INTO public.producto_precio VALUES (1004,1004 ,'2025-01-01',  '2030-12-31',1.00);
INSERT INTO public.producto_precio VALUES (1005,1005 ,'2025-01-01',  '2030-12-31',1.00);
INSERT INTO public.producto_precio VALUES (1006,1006 ,'2025-01-01',  '2030-12-31',0.75);
INSERT INTO public.producto_precio VALUES (1007,1007 ,'2025-01-01',  '2030-12-31',0.75);
INSERT INTO public.producto_precio VALUES (1008,1008 ,'2025-01-01',  '2030-12-31',1.50);
INSERT INTO public.producto_precio VALUES (1009,1009 ,'2025-01-01',  '2030-12-31',0.50);
INSERT INTO public.producto_precio VALUES (1010,1010 ,'2025-01-01',  '2030-12-31',1.00);
INSERT INTO public.producto_precio VALUES (1011,1011 ,'2025-01-01',  '2030-12-31',0.75);
INSERT INTO public.producto_precio VALUES (1012,1012 ,'2025-01-01',  '2030-12-31',0.75);
INSERT INTO public.producto_precio VALUES (1013,1013 ,'2025-01-01',  '2030-12-31',1.00);
INSERT INTO public.producto_precio VALUES (1014,1014 ,'2025-01-01',  '2030-12-31',0.80);
INSERT INTO public.producto_precio VALUES (1015,1015 ,'2025-01-01',  '2030-12-31',0.60);
INSERT INTO public.producto_precio VALUES (1016,1016 ,'2025-01-01',  '2030-12-31',0.50);
INSERT INTO public.producto_precio VALUES (1017,1017 ,'2025-01-01',  '2030-12-31',1.50);
INSERT INTO public.producto_precio VALUES (1018,1018 ,'2025-01-01',  '2030-12-31',0.60);
INSERT INTO public.producto_precio VALUES (1019,1019 ,'2025-01-01',  '2030-12-31',0.25);
INSERT INTO public.producto_precio VALUES (1020,1020 ,'2025-01-01',  '2030-12-31',0.60);

INSERT INTO public.orden VALUES (12345, '2025-03-03', 'Zarsa', true);
INSERT INTO public.orden VALUES (12346, '2025-03-04', 'S-Ana', true);
INSERT INTO public.orden VALUES (12347, '2025-03-05', 'SS', true);
INSERT INTO public.orden VALUES (12348, '2025-03-05', 'SS', true);
INSERT INTO public.orden VALUES (12349, '2025-03-05', 'SS', true);
INSERT INTO public.orden VALUES (123451, '2025-03-05', 'SS', true);


INSERT INTO public.producto_detalle VALUES (1001,1001 ,true, NULL);
INSERT INTO public.producto_detalle VALUES (1001,1002 ,true,  NULL);
INSERT INTO public.producto_detalle VALUES (1002,1003 ,true,  NULL);
INSERT INTO public.producto_detalle VALUES (1002,1004 ,true,  NULL);

INSERT INTO public.combo VALUES (1001, 'superCombo', true, '10 pupusas de cualquier especialidad y 3 cocas ','https://pollosreal.com/wp-content/uploads/2023/08/Pupusas-1024x1024.webp');
INSERT INTO public.combo VALUES (1002, 'megaCombo', true, '20 pupusas de cualquier especialidad y pepsis','https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Pupusas_El_Salvador_Centro_America.JPG/330px-Pupusas_El_Salvador_Centro_America.JPG');
INSERT INTO public.combo VALUES (1003, 'ultraCombo', true, '40 pupusas de cualquier especialidda + 3 pepsis','https://recetassalvadorenas.com/wp-content/uploads/2014/03/rosalba-e1504404527338.jpg');
INSERT INTO public.combo VALUES (1004, 'desayuno tradicional', true,'porcion huevos y casamiento junto platanos y un cafe','https://cdn.prod.website-files.com/65eaa6f14ade57080837bd43/65ebe5693083c7cc4feb71bb_Desayuno-Armenia.jpg');
INSERT INTO public.combo VALUES (1005, 'Amanecer Criollo', true, 'porcion de casamiento, platanos y queso freso y un cafe','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrwHUqLTQ0_q0Mw_fdh4RBWKQqrrXehvt_hw&s');
INSERT INTO public.combo VALUES (1006, 'amantes de la cafeina', true, '3 cafes','https://miro.medium.com/v2/resize:fit:540/1*bz6Gj2NAp3zfJoV6yBX5lw.jpeg');
INSERT INTO public.combo VALUES (1007, 'tarde tradicional', true, 'porcion de nuegados y atol','https://i.pinimg.com/236x/52/64/03/5264036e73e50052290096016375dc68.jpg');
INSERT INTO public.combo VALUES (1008, 'tarde de dulce', true, '5 empanadas de platano junto a un chocolate','https://www.tipicosmargoth.com/wp-content/uploads/2020/05/EMPANADA-DE-FRIJOL-TIPICOS-MARGOTH.jpg');

INSERT INTO public.combo VALUES (1009, 'tradiCombo', true, '2 tamales de elote, crema junto con un chocolate','https://comedera.com/wp-content/uploads/sites/9/2024/06/Tamales-de-Elote.jpg');

INSERT INTO public.combo VALUES (1010, 'sabor guanaco', true, '2 tamales de maiz  y un cafe','https://cocinaalchile.com/wp-content/uploads/2019/11/2.jpg');
INSERT INTO public.combo VALUES (1011, 'sabor guanaco2fdz', true, '2 tamales de maiz  y un cafe','https://cocinaalchile.com/wp-content/uploads/2019/11/2.jpg');

INSERT INTO public.combo_detalle VALUES (1001,1003,10,true);
INSERT INTO public.combo_detalle VALUES (1001,1001,3,true);
INSERT INTO public.combo_detalle VALUES (1002,1003,20,true);
INSERT INTO public.combo_detalle VALUES (1002,1002,5,true);
INSERT INTO public.combo_detalle VALUES (1003,1003,40,true);
INSERT INTO public.combo_detalle VALUES (1003,1002,5,true);
INSERT INTO public.combo_detalle VALUES (1004,1020,1,true);
INSERT INTO public.combo_detalle VALUES (1004,1011,5,true);
INSERT INTO public.combo_detalle VALUES (1004,1019,5,true);
INSERT INTO public.combo_detalle VALUES (1004,1012,5,true);
INSERT INTO public.combo_detalle VALUES (1005,1011,1,true);
INSERT INTO public.combo_detalle VALUES (1005,1019,1,true);
INSERT INTO public.combo_detalle VALUES (1005,1016,1,true);
INSERT INTO public.combo_detalle VALUES (1005,1012,1,true);
INSERT INTO public.combo_detalle VALUES (1006,1012,3,true);
INSERT INTO public.combo_detalle VALUES (1007,1009,5,true);
INSERT INTO public.combo_detalle VALUES (1007,1004,1,true);
INSERT INTO public.combo_detalle VALUES (1007,1014,1,true);
INSERT INTO public.combo_detalle VALUES (1008,1009,5,true);
INSERT INTO public.combo_detalle VALUES (1008,1013,1,true);
INSERT INTO public.combo_detalle VALUES (1009,1008,2,true);
INSERT INTO public.combo_detalle VALUES (1009,1017,1,true);
INSERT INTO public.combo_detalle VALUES (1009,1013,1,true);
INSERT INTO public.combo_detalle VALUES (1010,1007,2,true);
INSERT INTO public.combo_detalle VALUES (1010,1012,1,true);


-- 1. generar un ordenDetalle dado un IdOrden , un producto y una cantidad especifica por defecto la cantidad 1 , del producto se obtiene el idProducto y de este se busca su precio


-- 2. generar un ordenDetalle dado un combo y una cantidad de dicho combo,del combo se buscara su combo detalle y de este combo detalle
-- se obtendra el idProducto y del idProducto su IdPrecio de igual manera del combo detalle se obtine la cantidad de productos

-- 3. metodo mixto para los dos casos combinar los producto enviados junto con los productos de los combos
INSERT INTO public.orden_detalle VALUES (12345,1001,5,null,null);
INSERT INTO public.orden_detalle VALUES (12346,1002,6,null,null);
INSERT INTO public.orden_detalle VALUES (12347,1001,8,null,null);

INSERT INTO public.pago VALUES (1001,12345,'2025-03-03','contado',null);
INSERT INTO public.pago VALUES (1002,12346,'2025-03-03','contado',null);
INSERT INTO public.pago VALUES (1003,12347,'2025-03-03','contado',null);
INSERT INTO public.pago VALUES (1004,12347,'2025-03-03','contado',null);

-- generar un pago detalle dado un idPago del cual se obtendra el idOrden relacionado , delIdOrden se obtendra la lista OrdenDetalle relacionado y de este el precio y la cantidad para el monto
INSERT INTO public.pago_detalle VALUES (1001,1001,8.20,null);
INSERT INTO public.pago_detalle VALUES (1002,1002,8.20,null);
INSERT INTO public.pago_detalle VALUES (1004,1001,8.20,null);
INSERT INTO public.pago_detalle VALUES (1005,1001,8.20,null);
INSERT INTO public.pago_detalle VALUES (1006,1001,8.20,null);


--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 222
-- Name: orden_id_orden_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres


SELECT pg_catalog.setval('public.orden_id_orden_seq', 1, false);


--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 229
-- Name: pago_detalle_id_pago_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pago_detalle_id_pago_detalle_seq', 1, false);


--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 227
-- Name: pago_id_pago_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pago_id_pago_seq', 1, false);


--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 217
-- Name: producto_id_producto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_id_producto_seq', 1, false);


--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 220
-- Name: producto_precio_id_producto_precio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_precio_id_producto_precio_seq', 1, false);


--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 215
-- Name: tipo_producto_id_tipo_producto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_producto_id_tipo_producto_seq', 3, true);


--
-- TOC entry 3314 (class 2606 OID 25333)
-- Name: combo pk_combo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combo
    ADD CONSTRAINT pk_combo PRIMARY KEY (id_combo);


--
-- TOC entry 3318 (class 2606 OID 25339)
-- Name: combo_detalle pk_combo_detalle; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combo_detalle
    ADD CONSTRAINT pk_combo_detalle PRIMARY KEY (id_combo, id_producto);


--
-- TOC entry 3312 (class 2606 OID 25326)
-- Name: orden pk_orden; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden
    ADD CONSTRAINT pk_orden PRIMARY KEY (id_orden);


--
-- TOC entry 3320 (class 2606 OID 25359)
-- Name: orden_detalle pk_orden_detalle; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalle
    ADD CONSTRAINT pk_orden_detalle PRIMARY KEY (id_orden, id_producto_precio);


--
-- TOC entry 3322 (class 2606 OID 25380)
-- Name: pago pk_pago; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pk_pago PRIMARY KEY (id_pago);


--
-- TOC entry 3324 (class 2606 OID 25394)
-- Name: pago_detalle pk_pago_detalle; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago_detalle
    ADD CONSTRAINT pk_pago_detalle PRIMARY KEY (id_pago_detalle);


--
-- TOC entry 3306 (class 2606 OID 25286)
-- Name: producto pk_producto; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT pk_producto PRIMARY KEY (id_producto);


--
-- TOC entry 3308 (class 2606 OID 25294)
-- Name: producto_detalle pk_producto_detalle; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_detalle
    ADD CONSTRAINT pk_producto_detalle PRIMARY KEY (id_tipo_producto, id_producto);


--
-- TOC entry 3310 (class 2606 OID 25312)
-- Name: producto_precio pk_producto_precio; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_precio
    ADD CONSTRAINT pk_producto_precio PRIMARY KEY (id_producto_precio);


--
-- TOC entry 3304 (class 2606 OID 25276)
-- Name: tipo_producto pk_tipo_producto; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_producto
    ADD CONSTRAINT pk_tipo_producto PRIMARY KEY (id_tipo_producto);


--
-- TOC entry 3315 (class 1259 OID 25345)
-- Name: fki_combo_detalle_combo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_combo_detalle_combo ON public.combo_detalle USING btree (id_combo);


--
-- TOC entry 3316 (class 1259 OID 25351)
-- Name: fki_fk_combo_detalle_producto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_fk_combo_detalle_producto ON public.combo_detalle USING btree (id_producto);


--
-- TOC entry 3328 (class 2606 OID 25340)
-- Name: combo_detalle fk_combo_detalle_combo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combo_detalle
    ADD CONSTRAINT fk_combo_detalle_combo FOREIGN KEY (id_combo) REFERENCES public.combo(id_combo) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3329 (class 2606 OID 25346)
-- Name: combo_detalle fk_combo_detalle_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combo_detalle
    ADD CONSTRAINT fk_combo_detalle_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3330 (class 2606 OID 25360)
-- Name: orden_detalle fk_orden_detalle_orden; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalle
    ADD CONSTRAINT fk_orden_detalle_orden FOREIGN KEY (id_orden) REFERENCES public.orden(id_orden) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3331 (class 2606 OID 25365)
-- Name: orden_detalle fk_orden_detalle_producto_precio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalle
    ADD CONSTRAINT fk_orden_detalle_producto_precio FOREIGN KEY (id_producto_precio) REFERENCES public.producto_precio(id_producto_precio) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3332 (class 2606 OID 25381)
-- Name: pago fk_pago_orden; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT fk_pago_orden FOREIGN KEY (id_orden) REFERENCES public.orden(id_orden);


--
-- TOC entry 3325 (class 2606 OID 25295)
-- Name: producto_detalle fk_producto_detalle_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_detalle
    ADD CONSTRAINT fk_producto_detalle_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3326 (class 2606 OID 25300)
-- Name: producto_detalle fk_producto_detalle_tipo_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_detalle
    ADD CONSTRAINT fk_producto_detalle_tipo_producto FOREIGN KEY (id_tipo_producto) REFERENCES public.tipo_producto(id_tipo_producto) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3327 (class 2606 OID 25313)
-- Name: producto_precio fk_producto_precio_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_precio
    ADD CONSTRAINT fk_producto_precio_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3333 (class 2606 OID 25395)
-- Name: pago_detalle id_pago_detalle_pago; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago_detalle
    ADD CONSTRAINT id_pago_detalle_pago FOREIGN KEY (id_pago) REFERENCES public.pago(id_pago) ON UPDATE RESTRICT ON DELETE CASCADE;

