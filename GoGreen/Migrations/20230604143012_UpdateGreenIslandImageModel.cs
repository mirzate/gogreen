using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GoGreen.Migrations
{
    /// <inheritdoc />
    public partial class UpdateGreenIslandImageModel : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Images_GreenIslands_GreenIslandId",
                table: "Images");

            migrationBuilder.DropIndex(
                name: "IX_Images_GreenIslandId",
                table: "Images");

            migrationBuilder.DropColumn(
                name: "GreenIslandId",
                table: "Images");

            migrationBuilder.CreateTable(
                name: "GreenIslandImages",
                columns: table => new
                {
                    GreenIslandId = table.Column<int>(type: "int", nullable: false),
                    ImageId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GreenIslandImages", x => new { x.GreenIslandId, x.ImageId });
                    table.ForeignKey(
                        name: "FK_GreenIslandImages_GreenIslands_GreenIslandId",
                        column: x => x.GreenIslandId,
                        principalTable: "GreenIslands",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_GreenIslandImages_Images_ImageId",
                        column: x => x.ImageId,
                        principalTable: "Images",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_GreenIslandImages_ImageId",
                table: "GreenIslandImages",
                column: "ImageId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "GreenIslandImages");

            migrationBuilder.AddColumn<int>(
                name: "GreenIslandId",
                table: "Images",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Images_GreenIslandId",
                table: "Images",
                column: "GreenIslandId");

            migrationBuilder.AddForeignKey(
                name: "FK_Images_GreenIslands_GreenIslandId",
                table: "Images",
                column: "GreenIslandId",
                principalTable: "GreenIslands",
                principalColumn: "Id");
        }
    }
}
