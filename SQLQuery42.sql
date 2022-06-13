USE [KPIMonitoring]
GO
/****** Object:  StoredProcedure [dbo].[KPICR_Average_GET]    Script Date: 7/21/2014 5:10:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[KPICR_Average_GET](
	@Table CRSelectedTableType READONLY
)
AS
BEGIN

	SET NOCOUNT ON;

	select
		  SUM(xxx.[Time]) 		as [Time]
		, SUM(xxx.Cost)			as [Cost]
		, SUM(xxx.Deliverable)	as [Deliverable]
		, SUM(xxx.Compliance)	as [Compliance]
		, SUM(xxx.Supplier)		as [Supplier]

	from 
	(	
	select
	--  ISNULL(CONVERT(FLOAT, (SUM(TimeRank) / COUNT(*))),0.0)			AS [Time]
	  ISNULL(SUM(CAST(TimeRank AS FLOAT)) / COUNT(*), 0.0)			AS [Time]
	, 0	AS [Cost]
	, 0	AS [Deliverable]
	, 0	AS [Compliance]
	, 0	AS [Supplier] 
	from dbo.CR_KPI
	INNER JOIN @Table AS T ON CR_KPI.ID = T.ID
	where TimeRank is not null
	
	union all
	
	select
	  0	AS [Time]
	--, ISNULL(CONVERT(FLOAT, (SUM(CostRank) / COUNT(*))),0.0)			AS [Cost]
	, ISNULL(SUM(CAST(CostRank AS FLOAT)) / COUNT(*), 0.0)			AS [Cost]
	, 0	AS [Deliverable]
	, 0	AS [Compliance]
	, 0	AS [Supplier] 
	from dbo.CR_KPI
	INNER JOIN @Table AS T ON CR_KPI.ID = T.ID
	where CostRank is not null

	union all
	
	select
	  0	AS [Time]
	, 0	AS [Cost]
	--, ISNULL(CONVERT(FLOAT, (SUM(DeliverableRank) / COUNT(*))),0.0)	AS [Deliverable]
	, ISNULL(SUM(CAST(DeliverableRank AS FLOAT)) / COUNT(*), 0.0)	AS [Deliverable]
	, 0	AS [Compliance]
	, 0	AS [Supplier] 
	from dbo.CR_KPI
	INNER JOIN @Table AS T ON CR_KPI.ID = T.ID
	where DeliverableRank is not null
	
	union all
	
	select
	  0	AS [Time]
	, 0	AS [Cost]
	, 0	AS [Deliverable]
	--, ISNULL(CONVERT(FLOAT, (SUM(ComplianceRank) / COUNT(*))),0.0)	AS [Compliance]
	, ISNULL(SUM(CAST(ComplianceRank AS FLOAT)) / COUNT(*), 0.0)	AS [Compliance]
	, 0	AS [Supplier] 
	from dbo.CR_KPI
	INNER JOIN @Table AS T ON CR_KPI.ID = T.ID
	where ComplianceRank is not null

	union all
	
	select
	  0	AS [Time]
	, 0	AS [Cost]
	, 0	AS [Deliverable]
	, 0	AS [Compliance]
	, ISNULL(SUM(CAST(SupplierRank AS FLOAT)) / COUNT(*), 0.0)		AS [Supplier] 
	from dbo.CR_KPI
	INNER JOIN @Table AS T ON CR_KPI.ID = T.ID
	where SupplierRank is not null
	
	) XXX	
	
END

