using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GoGreen.Migrations
{
    /// <inheritdoc />
    public partial class UpdateEcoViolationModelAddMunicipality : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "MunicipalityId",
                table: "EcoViolations",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_EcoViolations_MunicipalityId",
                table: "EcoViolations",
                column: "MunicipalityId");

            migrationBuilder.AddForeignKey(
                name: "FK_EcoViolations_Municipalities_MunicipalityId",
                table: "EcoViolations",
                column: "MunicipalityId",
                principalTable: "Municipalities",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_EcoViolations_Municipalities_MunicipalityId",
                table: "EcoViolations");

            migrationBuilder.DropIndex(
                name: "IX_EcoViolations_MunicipalityId",
                table: "EcoViolations");

            migrationBuilder.DropColumn(
                name: "MunicipalityId",
                table: "EcoViolations");
        }
    }
}
