CREATE TABLE parents AS
  SELECT "abraham" AS parent, "barack" AS child UNION
  SELECT "abraham"          , "clinton"         UNION
  SELECT "delano"           , "herbert"         UNION
  SELECT "fillmore"         , "abraham"         UNION
  SELECT "fillmore"         , "delano"          UNION
  SELECT "fillmore"         , "grover"          UNION
  SELECT "eisenhower"       , "fillmore";

CREATE TABLE dogs AS
  SELECT "abraham" AS name, "long" AS fur, 26 AS height UNION
  SELECT "barack"         , "short"      , 52           UNION
  SELECT "clinton"        , "long"       , 47           UNION
  SELECT "delano"         , "long"       , 46           UNION
  SELECT "eisenhower"     , "short"      , 35           UNION
  SELECT "fillmore"       , "curly"      , 32           UNION
  SELECT "grover"         , "short"      , 28           UNION
  SELECT "herbert"        , "curly"      , 31;

CREATE TABLE sizes AS
  SELECT "toy" AS size, 24 AS min, 28 AS max UNION
  SELECT "mini"       , 28       , 35        UNION
  SELECT "medium"     , 35       , 45        UNION
  SELECT "standard"   , 45       , 60;


-- All dogs with parents ordered by decreasing height of their parent
CREATE TABLE by_parent_height AS
  SELECT child from parents, dogs where parent = name order by height desc;


-- The size of each dog
CREATE TABLE size_of_dogs AS
  SELECT dogs.name, sizes.size from dogs, sizes
    where sizes.min < dogs.height and dogs.height <= sizes.max;


-- Filling out this helper table is optional
CREATE TABLE siblings AS
  SELECT a.child as sib1, b.child as sib2, s1.size as size from parents as a, parents as b, size_of_dogs as s1, size_of_dogs as s2
where a.parent = b.parent and a.child < b.child and s1.name = a.child and s2.name = b.child and s1.size = s2.size;

-- Sentences about siblings that are the same size
CREATE TABLE sentences AS
  SELECT "The two siblings, "|| sib1 ||" plus "|| sib2 ||" have the same size: "|| size from siblings;

