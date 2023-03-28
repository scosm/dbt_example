# dbt_example

An example of how to use dbt. dbt lets you implement tests at the various stages along a data ingestion pipeline.
So, you can test that a transformation performed by dbt worked successfully, or that data ingested from an external source is complete and without corruption.
Data formats or the presence of nulls can be tested.
Thus, you can approach ETL (ELT) work from a more test-driven approach, as in software development.
Moreover, if a test fails, the faulty data is not ingested further. The older way allowed corrupt data to be ingested, and then test were performed
on the data at their end location, after ingestion. This results in the need to remediate data corruption, investigate where corruption has entered,
removing the faulty data, and then running a backfill to restore the corrected data--all steps typically performed manually.
But with dbt, ingestion of bad data is blocked. Test queries can report the specific nature and location of the data problems.

Another advantage of dbt is that you can break up a pipeline into stages. The transformations involved at each stage can therefore be simpler,
easier to read, easier to maintain. The "single responsibility" principle (from SOLID) can be applied here, so each stage is responsible for only one conceptual change.
Since each stage can have its own tests, the development process can have less risk--it's safer to develop and test one simple stage, rather than modify and test a large, monolithic transformation query.

This example is severed from the relevant databases, so it can't be run. But it can be read, showing how one might use dbt.
