USE AddressDB
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Addresses](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[Address1] [varchar](max) NULL,
	[Address2] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[StateProvince] [varchar](100) NULL,
	[Zip] [varchar](15) NULL,
	[Country] [varchar](75) NULL,
 CONSTRAINT [PK_Addresses] PRIMARY KEY CLUSTERED
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
