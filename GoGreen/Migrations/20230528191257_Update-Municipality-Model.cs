using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GoGreen.Migrations
{
    /// <inheritdoc />
    public partial class UpdateMunicipalityModel : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Images_Municipalities_MunicipalityId",
                table: "Images");

            migrationBuilder.DropIndex(
                name: "IX_Images_MunicipalityId",
                table: "Images");

            migrationBuilder.DropColumn(
                name: "Logo",
                table: "Municipalities");

            migrationBuilder.DropColumn(
                name: "MunicipalityId",
                table: "Images");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Logo",
                table: "Municipalities",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "MunicipalityId",
                table: "Images",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Images_MunicipalityId",
                table: "Images",
                column: "MunicipalityId");

            migrationBuilder.AddForeignKey(
                name: "FK_Images_Municipalities_MunicipalityId",
                table: "Images",
                column: "MunicipalityId",
                principalTable: "Municipalities",
                principalColumn: "Id");
        }
    }
}
