using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GoGreen.Migrations
{
    /// <inheritdoc />
    public partial class add_municipality_id_to_user_migration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "MunicipalityId",
                table: "AspNetUsers",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUsers_MunicipalityId",
                table: "AspNetUsers",
                column: "MunicipalityId");

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUsers_Municipalities_MunicipalityId",
                table: "AspNetUsers",
                column: "MunicipalityId",
                principalTable: "Municipalities",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUsers_Municipalities_MunicipalityId",
                table: "AspNetUsers");

            migrationBuilder.DropIndex(
                name: "IX_AspNetUsers_MunicipalityId",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "MunicipalityId",
                table: "AspNetUsers");
        }
    }
}
