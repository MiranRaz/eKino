using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eKino.Services.Migrations
{
    public partial class genericDatesProjection : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 1,
                column: "DateOfProjection",
                value: new DateTime(2024, 11, 12, 0, 38, 2, 241, DateTimeKind.Local).AddTicks(1230));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 2,
                column: "DateOfProjection",
                value: new DateTime(2024, 11, 15, 6, 36, 2, 241, DateTimeKind.Local).AddTicks(1310));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 3,
                column: "DateOfProjection",
                value: new DateTime(2024, 10, 21, 1, 57, 2, 241, DateTimeKind.Local).AddTicks(1330));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 4,
                column: "DateOfProjection",
                value: new DateTime(2024, 11, 16, 6, 33, 2, 241, DateTimeKind.Local).AddTicks(1350));
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 1,
                column: "DateOfProjection",
                value: new DateTime(2024, 10, 17, 3, 14, 12, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 2,
                column: "DateOfProjection",
                value: new DateTime(2024, 11, 6, 15, 22, 59, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 3,
                column: "DateOfProjection",
                value: new DateTime(2024, 11, 1, 7, 22, 59, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 4,
                column: "DateOfProjection",
                value: new DateTime(2024, 11, 7, 1, 22, 59, 0, DateTimeKind.Local));
        }
    }
}
