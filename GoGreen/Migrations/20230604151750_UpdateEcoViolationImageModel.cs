using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GoGreen.Migrations
{
    /// <inheritdoc />
    public partial class UpdateEcoViolationImageModel : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "EcoViolationImages",
                columns: table => new
                {
                    EcoViolationId = table.Column<int>(type: "int", nullable: false),
                    ImageId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_EcoViolationImages", x => new { x.EcoViolationId, x.ImageId });
                    table.ForeignKey(
                        name: "FK_EcoViolationImages_EcoViolations_EcoViolationId",
                        column: x => x.EcoViolationId,
                        principalTable: "EcoViolations",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_EcoViolationImages_Images_ImageId",
                        column: x => x.ImageId,
                        principalTable: "Images",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_EcoViolationImages_ImageId",
                table: "EcoViolationImages",
                column: "ImageId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "EcoViolationImages");
        }
    }
}
