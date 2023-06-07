using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GoGreen.Migrations
{
    /// <inheritdoc />
    public partial class AddModelTypeAndModelIdToImage : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "ModelId",
                table: "Images",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "ModelType",
                table: "Images",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ModelId",
                table: "Images");

            migrationBuilder.DropColumn(
                name: "ModelType",
                table: "Images");
        }
    }
}
