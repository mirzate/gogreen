using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GoGreen.Migrations
{
    /// <inheritdoc />
    public partial class RevertEcoViolationModel02 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_EcoViolations_AspNetUsers_UserId",
                table: "EcoViolations");

            migrationBuilder.DropIndex(
                name: "IX_EcoViolations_UserId",
                table: "EcoViolations");

            migrationBuilder.AlterColumn<string>(
                name: "UserId",
                table: "EcoViolations",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "UserId",
                table: "EcoViolations",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_EcoViolations_UserId",
                table: "EcoViolations",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_EcoViolations_AspNetUsers_UserId",
                table: "EcoViolations",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
