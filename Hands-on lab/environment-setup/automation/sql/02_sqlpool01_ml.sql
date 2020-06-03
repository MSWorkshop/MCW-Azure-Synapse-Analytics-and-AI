-- Replace <data_lake_account_key> with the key of the primary data lake account

CREATE DATABASE SCOPED CREDENTIAL StorageCredential
WITH
IDENTITY = 'SHARED ACCESS SIGNATURE'
,SECRET = '#DATALAKESTORAGEKEY#';

-- Create an external data source with CREDENTIAL option.
-- Replace <data_lake_account_name> with the actual name of the primary data lake account

CREATE EXTERNAL DATA SOURCE ASAMCWModelStorage
WITH
(
    LOCATION = 'wasbs://wwi-02@#DATALAKESTORAGEACCOUNTNAME#.blob.core.windows.net'
    ,CREDENTIAL = StorageCredential
    ,TYPE = HADOOP
);

CREATE EXTERNAL FILE FORMAT csv
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '',
        DATE_FORMAT = '',
        USE_TYPE_DEFAULT = False
    )
);

CREATE EXTERNAL TABLE [wwi_mcw].[ASAMCWMLModelExt]
(
[Model] [varbinary](max) NULL
)
WITH
(
    LOCATION='/ml/onnx-hex' ,
    DATA_SOURCE = ASAMCWModelStorage ,
    FILE_FORMAT = csv ,
    REJECT_TYPE = VALUE ,
    REJECT_VALUE = 0
);

CREATE TABLE [wwi_mcw].[ASAMCWMLModel]
(
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Model] [varbinary](max) NULL,
    [Description] [varchar](200) NULL
)
WITH
(
    DISTRIBUTION = REPLICATE,
    HEAP
);
