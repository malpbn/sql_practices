DROP TABLE IF EXISTS loan_approval_dataset;
-- Creando la tabla
CREATE TABLE loan_approval_dataset (loan_id INT, no_of_dependents INT, education VARCHAR(30), 
									self_employed VARCHAR(3), income_annum DECIMAL,
                                    loan_amount DECIMAL, loan_term DECIMAL, cibil_score DECIMAL,
                                    residential_assets_value DECIMAL, commercial_assets_value DECIMAL, 
                                    luxury_assets_value DECIMAL, bank_asset_value DECIMAL, 
                                    loan_status VARCHAR(30));

-- Importar datos a la tabla a través de un CSV (Table data import wizard de MySQL)

-- Exploración superficial de las combinaciones y datos
-- Mi primera hipotesis es que el cibil_score será la variable decisiva, independiente del income_annum

SELECT * FROM loan_approval_dataset;

-- Agruparé el loan_status y utilizaré el count para comparar las cantidades

SELECT loan_status, COUNT(loan_id) AS total_loan_status
FROM loan_approval_dataset
GROUP BY loan_status
ORDER BY total_loan_status DESC;

-- A la mayoría les han aprobado el prestamo. Voy a compararlo con la cantidad self_employed

SELECT self_employed, COUNT(loan_id) AS total_self_employed
FROM loan_approval_dataset
GROUP BY self_employed
ORDER BY total_self_employed;

-- La diferencia es minima entre los YES y NO, hay mucha paridad. No se concluye nada significativo

SELECT self_employed, loan_status, COUNT(loan_id) total_loan_status
FROM loan_approval_dataset
GROUP BY self_employed, loan_status
ORDER BY total_loan_status;

-- El ser trabajador autonomo no parece representar una razón de peso para la aprobación del prestamo
-- Es posible que agrupando por Education se pueden sacar más conclusiones

SELECT education, COUNT(loan_id) total_education_count
FROM loan_approval_dataset
GROUP BY education
ORDER BY total_education_count DESC;

-- La diferencia entre Graduados y No Graduados es minima, por lo que esto tampoco es un factor determinante
-- Los ingresos anuales deben ser sí o sí una variable determinante en la aprobación del prestamo

SELECT income_annum, loan_status FROM loan_approval_dataset
ORDER BY income_annum DESC
LIMIT 50;

-- Los ingresos anuales tampoco se trasladan directamente como una razón para aprobar el prestamo
-- La clave seguramente radica en el CIBIL_SCORE, mientras más alto sea este, más rapido se aprueba el prestamo

SELECT cibil_score, loan_status FROM loan_approval_dataset
ORDER by cibil_score DESC
LIMIT 50;

-- Como era de esperarse, la variable más importante es el cibil_score. Es el indicador directo de las cualidades del particular para adquirir un prestamo
-- Ahora considero importante comparar el loan_amount y el loan_term con el cibil_score y el loan_status
-- A mayor loan_amount, mayor debería ser el cibil_score y por consiguiente, un loan_status aprobado

SELECT loan_amount, loan_term, cibil_score, loan_status FROM loan_approval_dataset
ORDER BY loan_amount DESC
LIMIT 100;

-- Comprobada la hipotesis anterior, ahora analizaré la relación entre el loan_status rejected con loan_term, loan_amount y cibil_score

SELECT loan_amount, loan_term, cibil_score, loan_status FROM loan_approval_dataset
WHERE loan_status = 'Rejected'
ORDER BY loan_amount DESC
LIMIT 100;

SELECT loan_term, loan_status, COUNT(*) loan_term_total FROM loan_approval_dataset
WHERE loan_status = 'Rejected'
GROUP BY loan_term, loan_status
ORDER BY loan_term_total DESC;

-- Cuando el loan_term es mayor de 6, la cantidad de loan_status incremente de manera considerable
-- La influencia del no_of_dependents debería proyectarse en un mayor loan_term

SELECT no_of_dependents, loan_term, loan_status, COUNT(*) AS dependents_x_loan_term_and_status FROM loan_approval_dataset
GROUP BY no_of_dependents, loan_term, loan_status
ORDER BY dependents_x_loan_term_and_status DESC 
LIMIT 100;
