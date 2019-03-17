\i setup.sql

SELECT plan(17);

-- TESTING ONE CYCLE OF LINEAR CONTRACTION FOR A DIRECTED GRAPH

-- GRAPH 1 - 2 <- 3
PREPARE graph_e_1_2 AS
    SELECT id, source, target, cost, reverse_cost
FROM edge_table WHERE id IN (1, 2);

-- GRAPH 1 - 2 - 5
PREPARE graph_e_1_4 AS
    SELECT id, source, target, cost, reverse_cost
FROM edge_table WHERE id IN (1, 4);

-- GRAPH 6 -> 11 <- 10
PREPARE graph_e_11_12 AS
    SELECT id, source, target, cost, reverse_cost
FROM edge_table WHERE id IN (11, 12);

-- GRAPH 4 -> 3 -> 6 -> 11
PREPARE graph_e_3_5_11 AS
    SELECT id, source, target, cost, reverse_cost
FROM edge_table WHERE id IN (3, 5, 11);

-- GRAPH 6 -> 11 -> 12 - 9 - 6
PREPARE graph_e_9_11_13_15 AS
    SELECT id, source, target, cost, reverse_cost
FROM edge_table WHERE id IN (9, 11, 13, 15);


-- TWO EDGES

-- GRAPH 1 - 2 <- 3
-- no forbidden vertices
PREPARE v3e2q10 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_1_2',
    ARRAY[2]::INTEGER[], 1, ARRAY[]::INTEGER[], true);

PREPARE v3e2q11 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -2, ARRAY[1, 2]::BIGINT[], 3, 2, 3))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v3e2q10', 'v3e2q11', 'graph_e_1_2 QUERY 1: Directed graph with two edges and no forbidden vertices');

-- GRAPH 1 - 2 <- 3
-- 2 is forbidden
PREPARE v3e2q20 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_1_2',
    ARRAY[2]::INTEGER[], 1, ARRAY[2]::INTEGER[], true);

SELECT is_empty('v3e2q20', 'graph_e_1_2 QUERY 2: Directed graph with two edges and 2 is forbidden vertex');

-- GRAPH 1 - 2 - 5
-- 2 is forbidden
PREPARE graph_e_1_4_q1 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_1_4',
    ARRAY[2]::INTEGER[], 1, ARRAY[]::INTEGER[], true);

PREPARE graph_e_1_4_sol1 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -1, ARRAY[2]::BIGINT[], 1, 5, 2),
    ('e', -2, ARRAY[2]::BIGINT[], 5, 1, 2))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('graph_e_1_4_q1', 'graph_e_1_4_sol1', 'graph_e_1_4 QUERY 1: Directed graph with two edges and no forbidden vertices');

-- GRAPH 1 - 2 - 5
-- 2 is forbidden
PREPARE graph_e_1_4_q2 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_1_4',
    ARRAY[2]::INTEGER[], 1, ARRAY[2]::INTEGER[], true);

SELECT is_empty('graph_e_1_4_q2', 'graph_e_1_4 QUERY 2: Directed graph with two edges and 2 is forbidden vertex');


-- GRAPH 6 -> 11 <- 10
-- no forbidden vertices
PREPARE v3e2q30 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_11_12',
    ARRAY[2]::INTEGER[], 1, ARRAY[]::INTEGER[], true);

SELECT is_empty('v3e2q30', 'graph_e_11_12 QUERY 1: Directed graph with two edges and no forbidden vertex');

-- THREE EDGES

-- GRAPH 4 -> 3 -> 6 -> 11
-- no forbidden vertices
PREPARE v4e3q10 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_3_5_11',
    ARRAY[2]::INTEGER[], 1, ARRAY[]::INTEGER[], true);

PREPARE v4e3q11 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -2, ARRAY[3, 6]::BIGINT[], 4, 11, 3))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v4e3q10', 'v4e3q11', 'graph_e_3_5_11 QUERY 1: Directed graph with three edges and no forbidden vertices');

-- GRAPH 4 -> 3 -> 6 ->11
-- 3 is forbidden
PREPARE v4e3q20 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_3_5_11',
    ARRAY[2]::INTEGER[], 1, ARRAY[3]::INTEGER[], true);

PREPARE v4e3q21 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -1, ARRAY[6]::BIGINT[], 3, 11, 2))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v4e3q20', 'v4e3q21', 'graph_e_3_5_11 QUERY 2: Directed graph with three edges and 3 is forbidden vertices');

-- GRAPH 4 -> 3 -> 6 -> 11
-- 6 is forbidden
PREPARE v4e3q30 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_3_5_11',
    ARRAY[2]::INTEGER[], 1, ARRAY[6]::INTEGER[], true);

PREPARE v4e3q31 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -1, ARRAY[3]::BIGINT[], 4, 6, 2))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v4e3q30', 'v4e3q31', 'graph_e_3_5_11 QUERY 3: Directed graph with three edges and 6 is forbidden vertices');

-- 3, 6 are forbidden
PREPARE v4e3q40 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_3_5_11',
    ARRAY[2]::INTEGER[], 1, ARRAY[3, 6]::INTEGER[], true);

SELECT is_empty('v4e3q40', 'graph_3_5_11 QUERY 4: Directed graph with three edges and 3, 6 are forbidden vertices');


-- FOUR EDGES
-- GRAPH 11 -> 12 - 9 - 6 -> 11
-- no forbidden vertices
PREPARE v4e4q10 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_9_11_13_15',
    ARRAY[2]::INTEGER[], 1, ARRAY[]::INTEGER[], true);

PREPARE v4e4q11 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -4, ARRAY[6, 9, 11, 12]::BIGINT[], 6, 9, 3))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v4e4q10', 'v4e4q11', 'graph_9_11_13_15 QUERY 1: Directed graph with four edges and no forbidden vertices');

-- 6 is forbidden
-- GRAPH 6 -> 11 -> 12 - 9 - 6
PREPARE v4e4q20 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_9_11_13_15',
    ARRAY[2]::INTEGER[], 1, ARRAY[6]::INTEGER[], true);

PREPARE v4e4q21 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -1, ARRAY[9]::BIGINT[], 6, 12, 2),
    ('e', -2, ARRAY[9]::BIGINT[], 12, 6, 2),
    ('e', -3, ARRAY[11]::BIGINT[], 6, 12, 2))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v4e4q20', 'v4e4q21', 'graph_9_11_13_15 QUERY 2: Directed graph with four edges and 6 is forbidden vertices');

-- 9 is forbidden
-- GRAPH 6 -> 11 -> 12 - 9 - 6
PREPARE v4e4q30 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_9_11_13_15',
    ARRAY[2]::INTEGER[], 1, ARRAY[9]::INTEGER[], true);

PREPARE v4e4q31 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -2, ARRAY[6, 11]::BIGINT[], 9, 12, 3))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v4e4q30', 'v4e4q31', 'graph_9_11_13_15 QUERY 3: Directed graph with four edges and 9 is forbidden vertices');

-- GRAPH 6 -> 11 -> 12 - 9 - 6
-- 11 is forbidden
PREPARE v4e4q40 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_9_11_13_15',
    ARRAY[2]::INTEGER[], 1, ARRAY[11]::INTEGER[], true);

PREPARE v4e4q41 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -1, ARRAY[6]::BIGINT[], 9, 11, 2),
    ('e', -2, ARRAY[12]::BIGINT[], 11, 9, 2))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v4e4q40', 'v4e4q41', 'graph_9_11_13_15 QUERY 4: Directed graph with four edges and 11 is forbidden vertices');

-- GRAPH 6 -> 11 -> 12 - 9 - 6
-- 6, 9 are forbidden
PREPARE v4e4q50 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_9_11_13_15',
    ARRAY[2]::INTEGER[], 1, ARRAY[6, 9]::INTEGER[], true);

PREPARE v4e4q51 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -2, ARRAY[11, 12]::BIGINT[], 6, 9, 3))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v4e4q50', 'v4e4q51', 'graph_9_11_13_15 QUERY 5: Directed graph with four edges and 6, 9 are forbidden vertices');


-- GRAPH 6 -> 11 -> 12 - 9 - 6
-- 9, 11 are forbidden
PREPARE v4e4q60 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_9_11_13_15',
    ARRAY[2]::INTEGER[], 1, ARRAY[9, 11]::INTEGER[], true);

PREPARE v4e4q61 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -1, ARRAY[6]::BIGINT[], 9, 11, 2),
    ('e', -2, ARRAY[12]::BIGINT[], 11, 9, 2))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v4e4q60', 'v4e4q61', 'graph_9_11_13_15 QUERY 6: Directed graph with four edges and 9, 11 are forbidden vertices');

-- GRAPH 6 -> 11 -> 12 - 9 - 6
-- 6, 11 are forbidden
PREPARE v4e4q70 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_9_11_13_15',
    ARRAY[2]::INTEGER[], 1, ARRAY[6, 11]::INTEGER[], true);

PREPARE v4e4q71 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -1, ARRAY[9]::BIGINT[], 6, 12, 2),
    ('e', -3, ARRAY[9, 12]::BIGINT[], 11, 6, 3))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v4e4q70', 'v4e4q71', 'graph_9_11_13_15 QUERY 7: Directed graph with four edges and 6, 11 are forbidden vertices');

-- GRAPH 6 -> 11 -> 12 - 9 - 6
-- 6, 9, 11 are forbidden
PREPARE v4e4q80 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM pgr_contractgraph(
    'graph_e_9_11_13_15',
    ARRAY[2]::INTEGER[], 1, ARRAY[6, 9, 11]::INTEGER[], true);

PREPARE v4e4q81 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('e', -1, ARRAY[12]::BIGINT[], 11, 9, 2))
AS t(type, id, contracted_vertices, source, target, cost);

SELECT set_eq('v4e4q80', 'v4e4q81', 'graph_9_11_13_15 QUERY 8: Directed graph with four edges and 1, 2, 9 are vertices');

SELECT finish();
ROLLBACK;
