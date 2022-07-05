--  Translate table function
create function dbo.fn_RuEng
(
	@StringTable nvarchar(max)
)
	returns table
	as
	return
	(
		with RuEng as
		(
			select	ltrim(rtrim(split.t.value('.', 'nvarchar(255)'))) as val
			from
			(
				select cast ('<M>' + replace(@StringTable, ',', '</M><M>') + '</M>' as xml) as d
			) as t
			cross apply d.nodes ('/M') as split(t)
		)

		select	left(val,charindex('=',val)-1) as Eng,
			substring(val,charindex('=',val)+1,len(@StringTable)) as Ru
		from RuEng
	)
GO

-- Check it work
declare	@RuEng nvarchar(4000) = N'One=Один, Two=Два, Three=Три'
select * from dbo.fn_RuEng(@RuEng) as re