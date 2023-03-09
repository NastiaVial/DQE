WITH  
    json_string AS                
    (
        SELECT '[{"employee_id": "5181816516151", "department_id": "1", "class": "src\bin\comp\json"}, {"employee_id": "925155", "department_id": "1", "class": "src\bin\comp\json"}, {"employee_id": "815153", "department_id": "2", "class": "src\bin\comp\json"}, {"employee_id": "967", "department_id": "", "class": "src\bin\comp\json"}]' [str]
    ),
	json_data AS(
			SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
			(REPLACE([str],'[',''),']',''),', "class": "src\bin\comp\json"',''),'"',''),'{',''),' ',''),'},','}') as employee_data
			FROM  json_string
	),
	--Select * from json_data

	parse_string (string_1,string_2) AS(
			SELECT LEFT(employee_data,
						CHARINDEX('}',employee_data + '}')
						-1) AS string_1,
					STUFF(employee_data,
						1,
						CHARINDEX('}',employee_data + '}'),
						'') AS string_2
			FROM json_data
			UNION ALL 
			SELECT	LEFT(string_2,
						CHARINDEX('}',string_2 + '}')
						-1) AS string_1,
					STUFF(string_2,
						1,
						CHARINDEX('}',string_2 + '}'),
						'') AS string_2
			FROM parse_string	WHERE string_2 > ''
	),
	--Select * from parse_string

	divided_by_columns AS(
		SELECT left(string_1,
						CHARINDEX(',',string_1 + ',')
						-1)	AS employee_id,
				STUFF(string_1,
						1,
						CHARINDEX(',',string_1 + ','),
						'') AS department_id
		FROM parse_string),
	--Select * from divided_by_columns

	employee_table AS (
		SELECT  cast(replace(employee_id, 'employee_id:', '')AS BIGINT) AS employee_id,
				CASE WHEN cast(replace(department_id,'department_id:','') AS INT)=0 THEN NULL
				ELSE cast(replace(department_id,'department_id:','')AS INT)
				END AS department_id
		FROM divided_by_columns)

	Select	[employee_id],
			[department_id]
	FROM employee_table
