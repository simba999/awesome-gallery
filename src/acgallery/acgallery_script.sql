USE [master]
GO
/****** Object:  Database [ACGallery]    Script Date: 8/30/2016 10:05:23 AM ******/
CREATE DATABASE [ACGallery]
GO
ALTER DATABASE [ACGallery] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ACGallery].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ACGallery] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ACGallery] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ACGallery] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ACGallery] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ACGallery] SET ARITHABORT OFF 
GO
ALTER DATABASE [ACGallery] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ACGallery] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ACGallery] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ACGallery] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ACGallery] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ACGallery] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ACGallery] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ACGallery] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ACGallery] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ACGallery] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ACGallery] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ACGallery] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ACGallery] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ACGallery] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ACGallery] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ACGallery] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ACGallery] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ACGallery] SET RECOVERY FULL 
GO
ALTER DATABASE [ACGallery] SET  MULTI_USER 
GO
ALTER DATABASE [ACGallery] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ACGallery] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ACGallery] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ACGallery] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ACGallery] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'ACGallery', N'ON'
GO
ALTER DATABASE [ACGallery] SET QUERY_STORE = OFF
GO
USE [ACGallery]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [ACGallery]
GO
/****** Object:  Table [dbo].[Photo]    Script Date: 8/30/2016 10:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Photo](
	[PhotoID] [nvarchar](40) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[Desp] [nvarchar](100) NULL,
	[UploadedAt] [datetime] NULL,
	[UploadedBy] [nvarchar](50) NULL,
	[OrgFileName] [nvarchar](100) NULL,
	[PhotoUrl] [nvarchar](100) NOT NULL,
	[PhotoThumbUrl] [nvarchar](100) NULL,
	[IsOrgThumb] [bit] NULL,
	[ThumbCreatedBy] [tinyint] NULL,
	[CameraMaker] [nvarchar](50) NULL,
	[CameraModel] [nvarchar](100) NULL,
	[LensModel] [nvarchar](100) NULL,
	[AVNumber] [nvarchar](20) NULL,
	[ShutterSpeed] [nvarchar](50) NULL,
	[ISONumber] [int] NULL,
	[IsPublic] [bit] NULL,
	[EXIFInfo] [nvarchar](max) NULL,
 CONSTRAINT [PK_Photo] PRIMARY KEY CLUSTERED 
(
	[PhotoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlbumPhoto]    Script Date: 8/30/2016 10:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlbumPhoto](
	[AlbumID] [int] NOT NULL,
	[PhotoID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_AlbumPhoto] PRIMARY KEY CLUSTERED 
(
	[AlbumID] ASC,
	[PhotoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Album]    Script Date: 8/30/2016 10:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Album](
	[AlbumID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[Desp] [nvarchar](100) NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreateAt] [datetime] NULL,
	[IsPublic] [bit] NULL,
	[AccessCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_Album] PRIMARY KEY CLUSTERED 
(
	[AlbumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UX_AlbumTitle] UNIQUE NONCLUSTERED 
(
	[Title] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[View_Album]    Script Date: 8/30/2016 10:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Album]
AS
SELECT        dbo.Album.*, dbo.AlbumPhoto.PhotoID, dbo.Photo.PhotoThumbUrl
FROM            dbo.Album INNER JOIN
                         dbo.AlbumPhoto ON dbo.Album.AlbumID = dbo.AlbumPhoto.AlbumID INNER JOIN
                         dbo.Photo ON dbo.AlbumPhoto.PhotoID = dbo.Photo.PhotoID

GO
ALTER TABLE [dbo].[Album] ADD  CONSTRAINT [DF_Album_CreateAt]  DEFAULT (getdate()) FOR [CreateAt]
GO
ALTER TABLE [dbo].[Album] ADD  CONSTRAINT [DF_Album_IsPublic]  DEFAULT ((1)) FOR [IsPublic]
GO
ALTER TABLE [dbo].[Photo] ADD  CONSTRAINT [DF_Photo_UploadedAt]  DEFAULT (getdate()) FOR [UploadedAt]
GO
ALTER TABLE [dbo].[Photo] ADD  CONSTRAINT [DF_Photo_IsPublic]  DEFAULT ((1)) FOR [IsPublic]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Album"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AlbumPhoto"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 102
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Photo"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 136
               Right = 636
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Album'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Album'
GO
USE [master]
GO
ALTER DATABASE [ACGallery] SET  READ_WRITE 
GO
